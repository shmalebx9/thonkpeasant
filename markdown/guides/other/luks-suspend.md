---
abstract: LUKS encryption is an extremely useful way to keep your data safe. Running GRUB from your system firmware lets you get even more bang for your encryption-buck.
toc: true
title: Extremely Secure Full Disk Encryption with Suspend-to-Ram
...

This guide is aimed at helping those with a librebooted/corebooted system to take advantage of full disk encryption with LUKS2.
By the end of this guide you should have a system with an encrypted boot and root partition which will lock your root partition on suspend.

If you follow this guide then all your data will be encrypted when your computer is off.
Encrypting the boot partition according to this guide will also make your machine rootkit *resistant.*
With an unencrypted boot partition, an attacker could insert malicious code to save and transmit your root key on boot - totally defeating the purpose of full disk encryption.

*Note:* You will have to use a less secure encryption method for the boot partition due to the current limitation of GRUB2.
An attacker could, given sufficient time, brute force your boot partition to reveal the key.
As long as you use a different key for your root partition, this brute force attack would not compromise your documents/programs.
You should therefore use a much stronger and totally different key for your root partition.

This guide assumes that you already have an encrypted root partition in conjunction with an unencrypted boot partition.
An unencrypted boot partition is the standard way disk encryption is implemented.
If you selected 'full disk encryption' in a linux installer, then this is likely how your system works right now.
If you're lost, you should consult your distro's docs on creating a system with full disk encryption then come back.

**Use case/Motivation:**
This guide is useful for anyone who wants to secure against:

+ **Rootkits:**
	+ Even with less secure encryption, an attacker would need time to brute force the boot partition. This means that you can feel safe leaving your machine for several hours, knowing that an attacker isn't installing malicious code into your machine.
+ **Data theft:**
	+ This could be especially useful for attorneys facing unscrupulous airport security. If forced to hand over a machine with privileged information, an attorney could simply refuse to give his/her passphrase.


# Preliminary Note

Encrypting partitions on an existing machine will cause GRUB to fail until you've edited its configuration appropriately.
If you're coming from an existing system, you should keep a backup of your existing boot partition unencrypted.
Doing this means that during reboot you can simply change the 'set root' directive to point to your backup.
For example, if you create a new encrypted boot partition /dev/sda1 and backup your existing partition to /dev/sda3 then you can press 'e' at the grub menu and change the command:

```
set root=(ahci0,msdos1) # old
set root=(ahci0,msdos3) # new
```
You will then be able to boot normally by pressing <kbd>F10</kbd>.
NOTE: the partition names in grub will depend on what type of disk you use.

# Creating Encrypted Boot Partition

I recommend creating a separate boot and root partition.
Grub2 currently (Oct 2021) supports luks2 encryption, which is great, but only the (not very strong) PBKDF2 algorithm.
This means that you could create one single disk to cut down on password entries, but the entire disk would have to be less secure.
Instead, we'll create a purposely less secure /boot partition and a very secure root partition.
Start by creating a boot partition of around 1GB, you don't have to format it to anything as LUKS will overwrite it anyway.
If you're lost on how to do this, Gparted is a simple graphical program that comes with the parabola installer and will make things very easy.
Now that you have your new boot partition, you can proceed.
*Note:* Keep your old boot partition around if you have it, just make sure that the new partition is the first one on the partition table for your disk (/dev/sda1).

**Step 1:**
Create a LUKS2 formatted device with the PBKDF2 algorithm.
You can play around with the iteration count.
A higher iteration is more secure but will take GRUB a **very** long time to decrypt.
The [debian encrypted boot guide](https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html) recommends a count of 50,000 which will still take GRUB a very long time (around 25 seconds) but is faster than the default 100,000.
I'll use and arbitrarily low count.
You'll also want to use a different password than you intend to use (or already use) for your root partition.
We don't want someone to be able to get our root key by brute-forcing our less secure boot key.

`sudo cryptsetup luksFormat /dev/sda1 --type luks2 --pbkdf pbkdf2 --pbkdf-force-iterations 20000`

**Step 2:**
Format and mount the new LUKS2 device.
If you're installing a new system then you can simply mount your new device at /boot and install as normal.

```
sudo cryptsetup luksOpen /dev/sda1 boot
sudo mkfs.ext4 -L boot /dev/mapper/boot
sudo mkdir -p /mnt/luksboot
sudo mount /dev/mapper/boot /mnt/luksboot # for transition
sudo mount /dev/mapper/boot /boot # for installing
```

**Step 3:**
If you're transitioning an existing system, then copy the contents of /boot to the new encrypted partition.
If you already had a separate boot partition then you'll need to remount it, it will likely be /dev/sda3 if you only had a boot and root partition before starting this guide.
If not, then your boot files will be at /boot on your root partition.

```bash
sudo mount /dev/sda3 /boot # For a separate boot partition
sudo cp -r /boot/* /mnt/boot/ && sync
```

**Step 4:**
Comment out existing boot partition from your fstab.
If you don't then your system will hang on reboot because it can't mount the new LUKS device.

```
sudo vim /etc/fstab
#UUID=blah-blah-blah /boot ext4 defaults 0 1
```

# Set up Fstab

> The device holding the kernel (and the initramfs image) is unlocked by GRUB, but the root device needs to be unlocked again at initramfs stage, regardless whether it’s the same device or not. This is because GRUB boots with the given vmlinuz and initramfs images, but there is currently no way to securely pass cryptographic material (or Device Mapper information) to the kernel. Hence the Device Mapper table is initially empty at initramfs stage; in other words, all devices are locked, and the root device needs to be unlocked again.
>
> \- [Debian Guide](https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html)

**Step 1:**
Here, we're net trying to store the root key as we don't want to jeopardize the integrity of our root device.
Instead, we want to store the key for the boot device.

```
sudo mkdir -m0700 /etc/keys
su -c '( umask 0077 && dd if=/dev/urandom bs=1 count=64 of=/etc/keys/boot.key conv=excl,fsync )'
sudo cryptsetup luksAddKey /dev/sda1 /etc/keys/boot.key
```

**Step 2:**
Add your boot device to your crypttab.
You'll need to have the device's UUID.

```bash
lsblk -o 'PATH,LABEL,UUID' # to get UUID
sudo vim /etc/crypttab

> boot_crypt UUID=YOUR_UUID /etc/keys/boot.key luks,discard,key-slot=1
```
**Step 3:**
Add the crypt device to your fstab.
Use 'mount -a' to test your fstab configuration.
NOTE: you will not be able to mount the device until it has been unlocked and mapped, rebooting with your new crypttab should do this automatically.

```
sudo vim /etc/fstab

> /dev/mapper/boot_crypt /boot ext4 defaults 0 1
sudo mount -a
```

# Set up GRUB

If you already use my [libreboot builds](https://github.com/shmalebx9/Bleeding-Libreboot) then you are good to go, no further configuration should be needed.
You should note that this guide assumes you have GRUB 2.06 or later.
You'll need to make sure GRUB actually knows how to use your new encrypted device.
This part is very tricky, and get you into some hot water if you do something wrong, that's why you should keep an unencrypted backup of your boot partition just in case.

**Step 1:**
Get your default grub config for your distro.
You want to inspect the first menu entry for the variables you'll need.
I'll show mine as an example.

```
sudo cat /boot/grub/grub.cfg

menuentry 'Void GNU/Linux' --class void --class gnu-linux --class
gnu --class os $menuentry_id_option 'gnulinux-simple-349bfd43-40e0-41c9-84fe-94b599a0dcce' {
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod part_msdos
        insmod ext2
        set root='hd0,msdos1'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1  f9a998c1-ccf7-4133-9318-be5601286abc
        else
          search --no-floppy --fs-uuid --set=root f9a998c1-ccf7-4133-9318-be5601286abc
        fi
        echo    'Loading Linux 5.13.19_1 ...'
        linux   /vmlinuz-5.13.19_1 root=UUID=UUID_OF_ROOT_PARTITION ro  loglevel=4 rd.auto=1 cryptdevice=/dev/sda2:root
        echo    'Loading initial ramdisk ...'
        initrd  /initramfs-5.13.19_1.img
}
```

**Step 2:**
Get your current libreboot/coreboot rom.
If you get stuck, see the [internal flashing guide](/guides/flashing/flashin-internal.html)

```
sudo flashrom -p internal -r old.rom
cbfstool old.rom extract -n grub.cfg -f grub.cfg
```


**Step 3:**
Create a simplified menuentry based on the default one in the grub.cfg you extracted from your current rom.
You'll shouldn't need to do more than copy the kernel options (the text following 'linux').
See the config below for an example menuentry.

```
...
menuentry 'Load OS Directly [o]' --hotkey='o' {
        set gfxpayload=keep
        insmod gzio
        insmod part_msdos
        cryptomount (ahci0,msdos1)
        set root='crypto0'
        echo    'Loading Linux'
        linux   /vmlinuz root=UUID=349bfd43-40e0-41c9-84fe-94b599a0dcce ro loglevel=4 rd.auto=1 cryptdevice=/dev/sda2:root iomem=relaxed
        echo    'Loading initial ramdisk'
        initrd  /initramfs.img
}
...
```

In my example, I have the current initramfs and vmlinuz symbolically linked to the actual files in boot.
Doing this ensures that the rom we flash will always load the correct files.

```
sudo ln -s /boot/initramfs-5.13.19_1.img /boot/initramfs.img
sudo ln -s /boot/vmlinuz-5.13.19_1 /boot/vmlinuz-5.13.19_1
```

You need to be aware that this grub entry will always load those linked files, so you need to update the links if you upgrade your kernel.

**Step 4:**
Insert the new grub.cfg into your rom and flash it to your BIOS chip.

```
cbfstool old.rom remove -n grub.cfg -f grub.cfg
cbfstool old.rom add -f grub.cfg -n grub.cfg -t raw
sudo flashrom -p internal -w old.rom
```

# Set up Suspend-to-Ram

Once you unlock a LUKS device, the key is in memory.
If you suspend your machine by closing the lid (or manually), the key remains in memory.
LUKS encryption will therefore not protect any of the data on your root partition when you close the lid.
If an attacker raises the machine from suspend then they can already access your data.

The command 'luksSuspend' will flush the key from memory and protect your data until you re-enter your passphrase.
Unfortunately, once your disk is locked you cannot access any programs on your disk - including the crypsetup program to enter your passphrase!

To get around this problem, we can create a tiny linux system inside the boot partition which will have the tools to suspend our machine and decrypt our root partition.
You will then be able to secure your data without shutting down.

This guide will walk you through how to use my [portable LUKS suspend script](https://github.com/shmalebx9/luks-suspend-portable)

**Step 1:**
Clone the project from my github.

```
git clone https://github.com/shmalebx9/luks-suspend-portable
cd luks-suspend-portable
```

**Step 2:**
Extract the alpine linux rootfs to your boot partition.

```
sudo mkdir /boot/suspend
sudo tar xvf suspend-chroot.tar.gz -C /boot/suspend
```

**Step 3:**
Configure the suspend script to your liking.
The script currently uses Xsecurelock for screen locking and changes the keyboard layout before and after being run.
You will probably want to at least just remove the commands beginning with 'loadkeys.'
Once the script is to your liking, move it to somewhere it your *root user's* PATH and make it executable.

```
sudo cp zzzluks /usr/bin/
sudo chmod +x /usr/bin/zzzluks
```

Now you can test that the script is working:

`sudo zzzluks`

**Step 4:**
Make 'zzzluks' the default suspend action.
How this is done may differ by distro, and certain DE's will also have their own suspend settings.
On most systems though, this is just a matter of editing your acpi handler script and restarting the acpid service.

```
sudo vim /etc/acpi/handler.sh

...
 button/lid)
        case "$3" in
                close)
                        # suspend-to-ram
                        logger "LID closed, suspending..."
			#zzz
                        zzzluks
                        ;;
                open)   logger "LID opened" ;;
                *) logger "ACPI action undefined (LID): $2";;
        esac
        ;;
...
```

Now that you're done, you can restart the acpid service or simply reboot and you should find that your root disk is locked when you close the lid.
