---
abstract: A guide to creating a beautiful custom libreboot theme.
title: Libreboot Theming
toc: true
...

I have a few of my own libreboot builds available on [my gitbub.](https://github.com/shmalebx9/Bleeding-Libreboot)
By default my custom roms have:

+ Different font
+ Different background
+ Menu on the side
+ Ascii art
+ Beeps disabled

In this guide, I'll explain exactly what I did to get my builds to look this way.
By the end of this guide, you should be able to create your own themes either manually or by using my build system.

# Explanation

Libreboot is open source firmware for hardware initialization.
Libreboot will only initialize hardware and then pass to a payload.
The default payload for libreboot is GRUB.
Linux does not require an actual bios, which is why linux systems can be booted directly from GRUB in libreboot without a more complex payload.
GRUB can also chainload other payloads, such as seabios and tianocore which provide the ability to boot operating systems as a normal bios/EFI.

## GRUB with BIOS

You might notice when installing a linux distro to your machine, that an installer will ask you where to install GRUB (EFI is different, but I won't get into that here).
The installer is basically asking you which *physical disk* will hold your operating system(s).
When you select your disk (like /dev/sda) you might notice that the installer says something about "MBR on /dev/sdx."
The reason for that message is that GRUB isn't really installed to your OS like a normal program.
Instead, the code to run GRUB is placed in a special area of the disk called the *Master Boot Record* (MBR).
When a BIOS runs, it looks for a boot program in the MBR in order to load and operating system.

The MBR isn't the end of the story though.
You might notice that whenever you update your kernel or change your GRUB theme that you are editing files on one of the main partitions of your disk.
The <kbd>grub-install</kbd> command only runs when you first install your system, but the menu entries and theme can be changed without re-installing GRUB.
The reason for this is that GRUB sources a configfile when it first runs.
The configfile in question is generally located at /boot/grub/grub.cfg.
That configfile includes all of the menuentries you see when you start up your system and the modules needed to load your OS.
The configfile might also include the path to a theme file which defines the way GRUB menus appear, the fonts used, and the background image.

GRUB on a normal BIOS therefore works like this:

BIOS finds a disk with a bootloader (GRUB) and executes it > GRUB searches for a configfile on the disk to which it is installed and sources it > Configfile tells GRUB which boot options are available and sources a theme file if needed.

## GRUB with Libreboot

When you first [install libreboot](/guides/flashing/flashin-internal.html) you need to use an external programmer to rewrite the code that runs from your machine's BIOS chip.
If you download any of the standard ROMS or any of [my builds](https://github.com/shmalebx9/Bleeding-Libreboot) then the default payload is GRUB.
This means that instead of your firmware looking for a bootloader on the disk, it loads the bootloader (GRUB) from the get-go.

The GRUB that runs on the BIOS chip is (almost) the same as the GRUB that would run if it were loaded from your disk.
This means that we can do the same basic process to change the theme in libreboot's GRUB as we would do for a normal BIOS.
Instead of putting the configfile and theme file on the disk, we just put those files inside the ROM installed to the BIOS chip.

You probably have an EXT4 or btrfs partition on you computer's disk.
In the same way, you have a filesystem to read and separate files on your BIOS chip with libreboot.
The filesystem on you BIOS chip is the Corbeboot Filesystem (cbfs).
You can easily read and write from the filesystem on a libreboot ROM with the Coreboot Filesystem Tool (cbfstool).
You can install cbfstool from you distro's repos and then read the contents of a libreboot ROM.
For example, here is the output from a libreboot ROM:

```
 > cbfstool t400_8mb_usqwerty.rom print

FMAP REGION: COREBOOT
Name                           Offset     Type           Size   Comp
cbfs master header             0x0        cbfs header        32 none
fallback/romstage              0x80       (unknown)       58136 none
fallback/ramstage              0xe440     (unknown)      110231 LZMA (242648 decompressed)
config                         0x29340    raw               476 none
revision                       0x29540    raw               711 none
build_info                     0x29840    raw               100 none
fallback/dsdt.aml              0x29900    raw             15108 none
vbt.bin                        0x2d440    raw              1412 LZMA (3863 decompressed)
cmos.default                   0x2da00    cmos_default      256 none
cmos_layout.bin                0x2db40    cmos_layout      1840 none
fallback/postcar               0x2e2c0    (unknown)       20744 none
seabios.elf                    0x33440    simple elf      61348 none
etc/ps2-keyboard-spinup        0x42440    raw                 8 none
etc/pci-optionrom-exec         0x42480    raw                 8 none
etc/optionroms-checksum        0x424c0    raw                 8 none
etc/only-load-option-roms      0x42500    raw                 8 none
vgaroms/seavgabios.bin         0x42540    raw             25600 none
fallback/payload               0x48980    simple elf     626548 none
grub.cfg                       0xe1940    raw              6627 none
grubtest.cfg                   0xe3380    raw              6615 none
(empty)                        0xe4d80    null          7364452 none
bootblock                      0x7ead00   bootblock       20640 none
```

The seabios.elf file is what grub loads when pressing <kbd>B</kbd> at the main menu.
To see the nuts and bolts, we can extract the grub configuration file from the rom to inspect it further with `cbfstool t400_8mb_usqwerty.rom extract -n grub.cfg -f grub.cfg`.
You can see how grub chainloads seabios by inspecting the extracted config.

```
> grep -A2 'seabios' grub.cfg

if [ -f (cbfsdisk)/seabios.elf ]; then
menuentry 'Load SeaBIOS (payload) [b]' --hotkey='b' {
    set root='cbfsdisk'
    chainloader /seabios.elf
}
fi
```

You can view the various devices available from GRUB by pressing <kbd>c</kbd> on the GRUB menu and typing ls.
Generally, (cbfsdisk)/ is our ROM and (ahci0,msdos*x*)/ is one of the partitions on our disk.
Running <kbd>ls (cbfsdisk)/</kbd> will show you a similar output to what we see with cbfstool.

The file <kbd>grub.cfg</kbd> is the GRUB configfile loaded by libreboot when you start your machine.
Just like you can theme libreboot on a proprietary BIOS machine by editing the configfile in /boot/grub/grub.cfg, you can edit GRUB in libreboot by editing this file in the cbfs.

# Theming the GRUB Config

If you inspect the <kbd>grub.cfg</kbd> file from above you'll notice that it does not load any fonts, themes, or background images.
Since the rom isn't loading a font that can display the border box around text, these characters appear as '?' in the 20210522 testing release.
This issue can be fixed by adding a font to the rom image and telling grub to load it.
GRUB's default font can be found on most linux systems under <kbd>/boot/grub/fonts/unicode.pf2</kbd>
Add this font to the rom:

`cbfstool t400_8mb_usqwerty.rom add -f unicode.pf2 -n unicode.pf2 -t raw`

If you print the contents of the ROM, you'll find that it now includes the font we just added.
You can then place `loadfont (cbfsdisk)/unicode.pf2` near the top of the grub config to tell GRUB to use the font.
You can then remove the old grub config and replace it with the new one.

```
> cbfstool t400_8mb_usqwerty.rom remove -n grub.cfg
> cbfstool t400_8mb_usqwerty.rom add -f grub.cfg -n grub.cfg -t raw
```

# Creating a Theme

Grub itself supports some pretty extensive theming.
To create a grub theme, simply create <kbd>theme.txt</kbd> file and source it in the grub config <kbd>set theme=(cbfsdisk)/theme.txt</kbd>

After creating your theme, add the theme file, grub.cfg, and all fonts and backgrounds to the rom file with cbfstool.

The theme file can set all kinds of options such as the size and position of the boot menu, optional text, and background image.
The overflow in the following text allows you to see easier how the ascii art renders, don't worry that your browser has an error.
As an example, here is the contents of my GRUB theme from my github:

<pre style="background: var(--bgalt); color: var(--fgalt); margin-right: 0px; margin-left: 0px; border: 2px solid var(--cmain); border-radius: 10px; padding: 10px">
desktop-image: "background.png"
title-text: ""

terminal-border: "0"
terminal-left: "0"
terminal-top: "0"
terminal-width: "100%"
terminal-height: "100%"

+ boot_menu {
	left = 0%
	width = 40%
	top = 10%
	height = 60%
	item_color = "#ffffff"
        selected_item_color = "#02CCFC"
	item_height = 20
	item_padding = 5
	item_spacing = 15
}

+ vbox {
    left = 47%
    top = 15%
    width = 50%
    + label { width = 40 height = 20 color = "#ffffff" text = "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"}
    + label { width = 40 height = 20 color = "#ffffff" text = "██ ████▄ ▄██ ▄▄▀██ ▄▄▀██ ▄▄▄██ ▄▄▀██ ▄▄▄ ██ ▄▄▄ █▄▄ ▄▄█"}
    + label { width = 40 height = 20 color = "#ffffff" text = "██ █████ ███ ▄▄▀██ ▀▀▄██ ▄▄▄██ ▄▄▀██ ███ ██ ███ ███ ███"}
    + label { width = 40 height = 20 color = "#ffffff" text = "██ ▀▀ █▀ ▀██ ▀▀ ██ ██ ██ ▀▀▀██ ▀▀ ██ ▀▀▀ ██ ▀▀▀ ███ ███"}
    + label { width = 40 height = 20 color = "#ffffff" text = "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"}
}

+ vbox {
    left = 51%
    top = 40%
    width = 50%
    + label { width = 40 height = 20 color = "#ffffff" text = "                                ██  "}
    + label { width = 40 height = 20 color = "#ffffff" text = "                                 ██ ██"}
    + label { width = 40 height = 20 color = "#ffffff" text = "                                  ███"}
    + label { width = 40 height = 20 color = "#ffffff" text = "                              █████████████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "                                ████████ "}
    + label { width = 40 height = 20 color = "#ffffff" text = "                               ██████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "                               ██████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "                             ████████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "                         ████████████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "             ███████████████████████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "           ██████████████████████████████████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "           █████████████████████████     ███"}
    + label { width = 40 height = 20 color = "#ffffff" text = "          ████████████                 ███"}
    + label { width = 40 height = 20 color = "#ffffff" text = "      ███████████                   ████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "      ████████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "     ███"}
    + label { width = 40 height = 20 color = "#ffffff" text = "  ████"}
    + label { width = 40 height = 20 color = "#ffffff" text = "██"}
}

+ vbox {
    left = 5%
    top = 80%
    width = 40%
    + label { width = 40 height = 20 color = "#ffffff" text = "[↵] Boot selected Entry" }
    + label { width = 40 height = 20 color = "#ffffff" text = "[↑ and ↓ Key] Navigation" }
    + label { width = 40 height = 20 color = "#ffffff" text = "[E] Edit Selection" }
    + label { width = 40 height = 20 color = "#ffffff" text = "[C] GRUB Commandline" }
}
</pre>

If you flash this rom, you'll see something like this when you boot:


[![](/assets/theming/custom.webp)](/assets/theming/custom_orig.webp)

In order to conserve space, I use ascii art in my themes rather than editing the actual background image.
By doing so, we can compress the background image quite a bit, or even omit it entirely.
That way, the "libreboot" text and the logo are generated by GRUB whenever we boot up.
