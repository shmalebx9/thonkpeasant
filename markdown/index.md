---
toc: true
title: Why Old Thinkpads?
...

This site is aimed at giving comprehensive guides for using old thinkpads in the modern day.
If you want to jump into it, then head over to the [starting out](/guides/other/starting.html) guide.

For many people, the answer is simply the Intel Management Engine (IME).
This little subsystem runs in the background on basically every modern machine, transmitting your data who knows where.
The *IME* is also impossible to remove on any intel I-series chip.
I'll deal with the implication of both these problems in turn

## Privacy

The *IME* is totally opaque.
No one knows for sure what it's doing, only that it has access to **everything.**
It can read your encrypted data from memory when you decrypt it -rendering encryption basically useless- and transmit that data back to someone via the internet.

Now, many might reasonably point out that I've made the situation look bleak.
If US intelligence agencies and intel can see everything everyone with a modern computer is doing then they would catch basically every child predator and internet "criminal" (assuming they care to do so).
The fact that law enforcement has to resort to more analog investigative methods seems to show that the *IME* has some limits.

Even if the *IME* isn't a perfect back-door, it is still a clear threat.
No one knows this better than US intelligence agencies themselves.
The NSA is (as far as anyone knows) the only entity entitled to buy intel chips without the management engine.
Even if one assumes that the engineers behind the curtain took every possible step to make sure the *IME* could only be used by the "good guys," it should need no proof to say that the engineers working for the "bad guys" have been trying their hardest to gain access ever since.
It's therefore possible -even probable- that China, Russia, North Korea, or your favourite world "bad guys" already have access to machines with the *IME.*

## Freedom

The fact that the *IME* is made impossible to remove is a massive slap in the face to user freedom.
Effectively, the machine that you bought with your own money isn't yours.
If you use a modern machine, you are in a sense simply licensing the use of the machine contingent on leaving the back door open.

If you want a machine that is **totally** free, then you have to use an older machine without the newer *IME.*
Once you libreboot your thinkpad and install a FOSS OS, you are the master of the machine.
Every line of code is accessible, and every decision is yours.

# Other Benefits

Freedom from intel, and the security of your data from the *IME* are far from the only reasons to want an old thinkpad.
Old thinkpads have hardware that is in many ways *superior* to modern machines.

## Encryption

I apologize if the foregoing explanation is pedantic, but it's necessary for the noobish audience I'm writing for.

On any normal computer, when you hit the power button to turn on your machine a signal is sent to your BIOS chip.
The code written to that chip is your BIOS.
The BIOS then -absent user intervention- starts looking for a bootable device.
The BIOS will eventually find a *bootloader* on one of the devices it checks (generally your ssd/hdd) and execute it.
If you have a classic BIOS, then the bootloader is in the *master boot record* of the disk, if it is an EFI disk, then your firmware will be checking a special EFI partition.
Either way: the bootloader then loads your operating system from the disk.

For almost all linux systems, the bootloader in question is GRUB2.
GRUB's role is to find an initial ramdisk (generall initramfs in a /boot partition) and a kernel (generally vmlinuz-x-x-x) on the disk and load them into memory.
You can think of it as GRUB passing ownership of your hardware to your operating system.
When GRUB sees that you have an encrypted disk, it has the tools to prompt you for a password, decrypt the disk, and then load the operating system from the (now readable) disk.
GRUB therefore has a lot of power.

If you already have an encrypted disk, then you know that your data is safe *at rest.*
When you shut off your computer, all of the data on your disk is unreadable by an attacker.
But what would a sophisticated attacker do if they happened upon your fully encrypted disk?
Your encrypted data is unreadable, but GRUB isn't!
Since your firmware needs to execute a bootloader, that bootloader must be unencrypted.
An attacker could therefore edit the plainly viewable GRUB code to insert a rootkit.
The rootkit could potentially store your key, transmit it to the attacker, or outright transmit your unencrypted data back to the attacker.

Libreboot/Coreboot defeat the rootkit vulnerability of GRUB on your disk.
Since you flash your own firmware, you can choose to have GRUB run as *part of the firmware* on your BIOS chip.
In fact, GRUB2 is the default payload for libreboot (for now).
Since there is no need for a bootloader on your disk, an attacker can't do anything with your encrypted disk.
When you input your key now, no program on your disk has access to it until GRUB loads your OS.
An attacker can't make any changes to the OS on your disk because everything is fully encrypted.

## End User Advantages

The main advantage of using an old thinkpad for your daily driver is the keyboard.
This advantage cannot be overstated.
Modern chiclet keyboards simply cannot compete with the satisfying crunch of an old thinkpad keyboard.
After spending a day or two using a classic keyboard, you will feel actual physical pain on a modern laptop.
If you type for hours a day, then your fingers will thank you for using a classic thinkpad keyboard.

Another advantage of old thinkpads is the screen's aspect ratio.
16:10 might not seem a whole lot different than 16:9 in numerical terms, but the difference is huge.
The only "benefit" of 16:9 is that you don't see black borders when you watch a video in full screen mode.
In basically *every* other domain, 16:10 is superior.
More vertical space means you can see more and do more in a way that you won't notice until you have to switch back to a squashed screen.

