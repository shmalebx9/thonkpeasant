---
abstract: The X200 is overrated in my humble opinion. The immense popularity of this tiny workstation however, makes it a stellar candidate for a freedom injection
title: Thinkpad X200 Libreboot Guide
...

If it's you're first time, you should definitely check out the [general libreboot guide](/guides/flashing/general.html) before flashing.

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

The tear-down for the X200 is exceedingly simple, but I'll detail it just in case.

**Step 1:**
Remove the screws marked with the keyboard or palmrest logo from the bottom of the machine.
When in doubt, just unscrew.
All of the screws are the same, so you needn't worry.

**Step 2:**
Remove the keyboard and palmrest by just prying them up.

[![](/assets/x200-libreboot-guide/x200topView.webp)](/assets/x200-libreboot-guide/x200topView_orig.webp)

**Step 3:**
Unplug the Keyboard and palmrest.

[![](/assets/x200-libreboot-guide/x200Unplug.webp)](/assets/x200-libreboot-guide/x200Unplug_orig.webp)

## Flashing

You can now proceed to [flashing,](/guides/flashing/flashing.html) the bios chip located above the ram slots.
