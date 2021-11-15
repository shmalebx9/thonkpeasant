---
title: Starting Out With Libreboot
toc: true
abstract: A simple introduction to libreboot. This guide will tell you everything you need to know to get the top-performing fully free thinkpad you can get.
...

<style>
.indexentry {
	margin: 14px 7px 0px;
	display: block;
	float: left;
	min-height: 80px;
	width: 90%;
}
@media screen and (min-width: 800px) {
	.indexentry {
	width: 45%
	}
}
</style>

This guide assumes you know nothing at all about libreboot or old thinkpads.
By the end of this guide, you'll hopefully get an idea of how to get a perfect setup like my own.

## What Is? How Do?

Libreboot is simply a FOSS alternative to the proprietary firware on your machine.
Libreboot will initiate your hardware (CPU and RAM) and then load a *payload.*
The payload is what you'll actually see and use once you've installed libreboot, but it is distinct from libreboot itself.
GRUB is the standard payload, it's the default bootloader for basically any x86 linux system.
Seabios, is another payload which is more similar to a basic BIOS.

If you choose to install any of my libreboot builds, your system will boot to GRUB with the option to load Seabios as well.
The GRUB configuration inside my builds (and mainline libreboot) is fairly robust, but it may fail to load some liveUSBs.
For most users, this means that you can libreboot your machine, load your installer usb from Seabios, then let libreboot load your installed OS without any user intervention.
It works this way because the GRUB config inside libreboot will find your distro's GRUB config in your /boot partition/directory and *source* it.
To be clear, libreboot is not *chainloading* GRUB from your hard drive, it is just using your distro's config on the GRUB payload running in libreboot.	
You needn't install a bootloader when you install your OS, becaus it will just be skipped over; it won't hurt though.
If you're unsure, just follow your distro's install guide including the GRUB installation and enjoy your OS without any issues.

If the information above seems opaque, then don't worry.
Once you install libreboot you will not need to know anything I've explained in this section.
All you really need to understand is that if your liveUSB fails to boot from GRUB, then select Seabios, press <kbd>Esc</kbd> and then select your usb.

The next sections will detail the steps to installing libreboot on any thinkpad.

## Update Embedded Controller

The embedded Controller *(EC)* is firmware on your machine that handels physical input like your keyboard.
Lenovo has released a few different versions of this firmware since they made the machines.
The EC that came with your machine is *likely* fine, and you won't experience any issues using it.
EC updates can only be done with a stock BIOS, so you should just update it before installing libreboot.
Lenovo/IBM offer an EC updater for proprietory gatezware (Windows) as well as an update CD.
If your machine came with windows, then you can boot to windows, download the update utility, and run it.
If you don't have windows installed, or you just don't want to wait 10,000 hours to boot it and enter hell, then you can covert the update CD to a USB image then boot your usb and run the utility.

You can check your EC version by pressing <kbd>F1</kbd> at your BIOS splash screen.
The table below shows the latest version for different models.
You need to update the EC if your version is different than what's listed in the table.
For other models, refer to the [Thinkwiki page.](https://www.thinkwiki.org/wiki/BIOS_Upgrade_Downloads)

| Machine | Version |
|:-------:|:-------:|
| T400 | 1.06 |
| T500 | 1.06 |
| W500 | 1.06 |
| X200 | 1.06 |
| X200t | 1.06 |
| X200s | 1.06 |
| T400s | 1.02 |

**Step 1:**
Download my EC update image.
This image will work on any USB with at least 2GB of storage.
I have an image which you can download [here.](https://drive.google.com/file/d/1pbhlaQ-Chnqt9NXDsuUPXFdfSBXQYjr-/view?usp=sharing)
That image can be used to update the EC on a T400/R400/T400/R500/W500/X200.

**Step 2:**
Extract the image.

`unxz ECUpdate.img.xz`

**Step 3:**
Determine your which device is your USB drive.
Your usb is probably /dev/sdb.
Run lsblk before and after inserting the USB if you're unsure, the new entry is your usb.

**Step 4:**
Flash the image to the usb.
This command assumes your usb drive is /dev/sdb.
You need to be certain of which device is your usb as dd will completely destroy **all** existing data on the device.

`sudo dd if=ECUpdate.img of=/dev/sdb bs=4M status=progress && sync`

**Step 5:**
Boot from the usb by pressing <kbd>F12</kbd> at the BIOS splash screen.
Follow the instructions to update your EC.
*Note:* the utility will not work unless your battery is fully charged and your machine is connected to power.

## Libreboot the Machine

<a href=/guides/flashing/t400-libreboot.html><div class=indexentry>
**Thinkpad T400 Libreboot Guide**

The T400 is my preferred machine for daily use. In this guide, you'll learn how to make it your own.
</div></a>
<a href=/guides/flashing/t500-libreboot.html><div class=indexentry>
**Thinkpad T500 Libreboot Guide**

This machine is the biggest and baddest libreboot-compatible laptop on the market. Free this beast and join the FOSS gang.
</div></a>
<a href=/guides/flashing/x200-libreboot.html><div class=indexentry>
**Thinkpad X200 Libreboot Guide**

The X200 is overrated in my humble opinion. The immense popularity of this tiny workstation however, makes it a stellar candidate for a freedom injection
</div></a>
<div style="clear:both;"></div>

## Make it Awesome

Now you can proceed to put a quad core processor in your machine if you went with a T400/T500.
Apply the cooling mod as well to make sure your quad machine doesn't overheat.
If you want, you can now create a fully encrypted machine as well.

<a href=/guides/other/cool.html><div class=indexentry>
**T400/T500 Cooling Mod**

This guide shows you how to improve cooling on your machine. This is especially usefull if you have done the quad mod.
</div></a>
<a href=/guides/other/luks-suspend.html><div class=indexentry>
**Extremely Secure Full Disk Encryption with Suspend-to-Ram**

LUKS encryption is an extremely useful way to keep your data safe. Running GRUB from your system firmware lets you get even more bang for your encryption-buck.
</div></a>
<a href=/guides/other/quad.html><div class=indexentry>
**T400/T500 Quad Mod Guide**

The quad mod is a must for pushing your old thinkpad to compete with modern hardware. This guide makes the process easy for first timers; even if you've never touched a soldering iron.
</div></a>
