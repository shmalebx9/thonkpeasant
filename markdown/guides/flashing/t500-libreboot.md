---
abstract: This machine is the biggest and baddest libreboot-compatible laptop on the market. Free this beast and join the FOSS gang.
title: Thinkpad T500 Libreboot Guide
...

This guide is aimed at noobs who have never taken apart a laptop before.
The [official libreboot guide](https://libreboot.org/docs/install/t500_external.html) has more pictures but does not have the screw location maps in this guide.
If you get stuck, you can always refer back to the official guide and come back here when you have to put the machine back together.

## Tools

You'll need SPI flashing equipment in order to follow this guide.
The official Libreboot documentation recommends against the Raspberrypi Pi as it supports some nonfree software (inter alia).
You can use basically any board with the correct GPIO pins but you'll have to determine the pinout yourself.
I find that since most guides are written for the Pi and a lot of people (including me) have them already, it's a decent choice.

---------------------------------------------------------------------------------------------------------------------
**Item**                    **Notes**                                                   **Link**
--------------------------- ----------------------------------------------------------- -----------------------------
SBC for SPI flashing        If you don't know where to                                  [Raspberrypi.com](https://www.raspberrypi.com/products/)
                            start, just go with the raspberry pi 3B 

Dupont Cables               There are lots of places                                    [Amazon](https://www.amazon.ca/RGBZONE-Multicolored-Breadboard-Arduino-Raspberry/dp/B08TWSV2DY)
                            to get these for very cheap 

SOIC clip(s)                Finding these things outside mainland china is              [Valuetronics - 8MB](https://www.valuetronics.com/product/5252-pomona-accessory-new)  [Valutronics - 4MB](https://www.valuetronics.com/product/5250-pomona-clip-new)
                            almost impossible. The link provided is afaik
                            the only place to get them at a reasonable price
                            in North America.

Thermal paste\*             MX-4 is the standard thermal paste.                         [Amazon](https://www.amazon.com/ARCTIC-MX-4-2019-Performance-Durability/dp/B07L9BDY3T)

Wireless Card               The intel wifi cards installed by default are not           [Amazon](https://www.amazon.com/Yosoo-Network-Atheros-Wireless-Bluetooth/dp/B07L1PJGG2/)
                            supported with free software. You'll need to install
                            a new one in order to use wifi after installing
                            libreboot. Most atheros cards will work. Just make
                            sure the card you get is for PCI mini express,
                            not PCI mini.
------------------------------------------------------------------------------------------------------------------------

## Machine Tear-Down

There are two basic ways to go about tearing down your T500:

1. Completely disassemble the machine down to the motherboard to reveal the SOIC chip
2. Remove only the keyboard and palmrest then break off part of the roll cage

Method one is the recommended route as it causes no damage to the machine.
The first method also includes repasting the cpu, which is probably a good idea since the factory paste is quite old and not that great in the first place.
Method two is preferable if you don't have any thermal paste and you want to get the job done as quickly as possible.
The two methods are not mutually exclusive.
On my personal machine I followed method one to repaste the cpu and perform the quad-core mod and then broke off the piece of the roll cage to allow easy flashing in the future.
This guide will detail both methods.

**Step 1:**
Remove all screws from the bottom of the machine.
The picture below shows where all the screws go; which will be especially helpfully when it comes time to reassemble the machine.
*Note:* If you're going with method two, you only need to remove screws marked with the keyboard/palmrest logo.

| | |
|:-:|:-:|
| [![](/assets/t400-libreboot-guide/screwguide_t400.webp)](/assets/t400-libreboot-guide/screwguide_t500_orig.webp) | [![Click to Enlarge](/assets/t500/backScrews.webp)](/assets/t500/backScrews_orig.webp) |

**Step 2:**
Remove the keyboard and palmrest.
I recommend using a plastic pry-tool, but you can use something metal or even your fingers to pry them off.

**Step 2A:**
If you chose to go with method two then you can break off the piece of the roll cage to reveal the bios chip.
If you don't want to repaste the machine then you can skip to [flashing.](#flashing)

[![](/assets/t400-libreboot-guide/cut_rollcage.webp)](/assets/t400-libreboot-guide/cut_rollcage_orig.webp)

**Step 3:**
Remove the bezel and metal guard.
If you have trouble getting the top bezel to pop out, try wiggling it back and forth until one of the clips detaches.
The top bezel should then come off with ease by lightly pulling all around the perimeter.
After removing the bezel, proceed to remove all the marked screws and unplug everying marked 'UP.'

[![](/assets/t500/topview.webp)](/assets/t500/topview_orig.webp)

**Step 4:**
Remove the speakers and the screws holding in the display.
You can then unplug the display cable and pull the lcd assembly off.

[![](/assets/t500/displaySpeakers.webp)](/assets/t500/displaySpeakers_orig.webp)

**Step 5:**
Remove the wifi card, unplug the heatsink, and unscrew one front screw.
When you detach the wifi card's wires you should be gentle, as they can break if you man-handle them.
lightly pulling upwards on the wires while wiggling should easily detach the wifi antenna wires.
As you remove the speakers and wifi card you'll have to remove the tape holding their wires in place.

[![](/assets/t500/FanFront.webp)](FanFront_orig.webp)

**Step 6:**
Remove the entire heatsink.
Remove the ultrabay (generally a cd-reader) and the hard drive.
Remove the roll cage and motherboard from the bottom casing by lifting up from the right side.

[![](/assets/t400-libreboot-guide/sep_rollcage.webp)](/assets/t400-libreboot-guide/sep_rollcage_orig.webp)

**Step 7:**
Flip the roll cage over and unscrew the motherboard.
You can then remove the motherboard itself.
Flipping it over, you should now see the soic chip you'll be flashing.

[![](/assets/t500/moboBottom.webp)](/assets/t500/moboBottom_orig.webp) 
![](/assets/t500/chipLocation.webp)

## Flashing

You can now proceed to [flashing,](/guides/flashing/flashing.html) the bios chip located above the ram slots.
Make sure to reinsert the sim-card reader between the motherboard and roll cage before screwing the motherboard back on.
You should also make sure to locate a small black plastic spacer which goes under the sim card reader in case it fell out.
You should follow this guide in the reverse during reassembly to make sure everything is in its proper place.
You can use any tape to secure the wires you unrouted earlier as the tape you pulled off will have difficulty sticking again (just make sure your tape isn't flammable).

