---
abstract: A map of the thinkpad landscape. This guide details features, usage, and my opninion of various thinkpad models.
title: Comparison of Various Thinkpads
...

This guide should start as a jumping-off point for new users interested in using thinkpads.
If you've heard buzz on the internet about these machines, but don't know where to start, then this guide is for you.

## Nomenclature

Naming conventions for year of release switched in 2008 from double, to triple digit suffixes.
After this switch, the numeric suffix incremented by ten every release cycle.
Thus, the T410 is the model released after the T400, the X230 after the X220 and so on.
There are still some of the old double digit models around, but they're not too common.
The most common of the old naming structure are the T60/T61, and the T60, which were released just before the naming change.

Thinpads can generally be separated into three folk categories: classic, modern, and contemporary.
The names for these categories are my own, but the differences between them are well known to users.
In general, classic thinkpads are all machines up to the '300 lineup released in 2012.
The line between modern and contemporary is more blurred.
Construed narrowly though, modern thinkpads are the '300 and '400 series.
Contemporary thinkpads are -of course- everything released after the '400 series.

IBM/Lenovo further categorizes thinkpads into the X, T, R, W prefixes.
The table below sets out the characteristics of each letter series.

------------------------------------------------------------------------------------
 Prefix  Description
-------- ---------------------------------------------------------------------------
**X**    Thin and light compared to other thinkpads. Screen size under 13". Good for
         very basic casual computing. Soldered CPU.

**T**    Mid-sized machine. Sreen size 14-15". Stable performance for moderate use
         including moderate intensity code compilation.

**R**    Same as T series but generally lower build quality and internals.

**W**    Desktop replacement machines. Screen size 15". Highest performance due to
         better heat management. Very beefy.
------------------------------------------------------------------------------------

Some models additionally include a suffix.
The suffix specifies the type of variation on that model.
These machines are less common, but still see some use.

------------------------------------------------------------------------------------
 Suffix  Description
-------- ---------------------------------------------------------------------------
**t**    Stands for "tablet." The screen can swivel in any direction
         and generally has a touch screen.

**s**    Stands for "slim." Thinner version with a soldered CPU.

**p**    Stands for "power." Higher spec'd machine. Usually thicker.
------------------------------------------------------------------------------------

With the above information, you can easily distinguish classic and modern thinkpad models.
For example, the T410s is the slim mid-sized laptop released in the 2009 release cycle.

## Libreboot

Libreboot supports the '60/61 and '00 series thinkpads.
By far, the most popular choice is the X200.
My favourite librebootable machine (which I'm using right now) is the T400.
The following table shows thinkpads supported by libreboot and notes on the hardware.

------------------------------------------------------------------------------------
**Machine**  **Notes**
------------ -----------------------------------------------------------------------
**X200**     This is the easiest machine to libreboot because it does not require
             any complex disassembly. You need only remove the keyboard and palm
	     rest to access the SOIC chip.

**T400**     Moderate difficulty. Requires a full tear-down to libreboot. The
             tear-down isn't necessarily difficult, but it is time-consuming
	     on the first try. 

**R400**     Same as T400 but not as rugged.

**T500**     Basically the same as the T400 except with a larger screen. Like the
             T400, this machine supports quad cpus.

**W500**     Functionally identical to the T500. Probably supports Quad cores as
             well. This machine could be the fastest librebooted machine with a
	     Quad, but likely not by much. This machine is probably too large
	     for the modern user.

**T60**      This is a thinkpad purist's dream. Unfortunately very slow and old.
             I personally would not reccomend. Requires dealing with BUCTS, which
	     adds moderate complexit.

**X60**      Same as T60.

**X200s**    Slower machine. Also may require replacing the screen. Moderate
              difficulty.

**X200t**    Comes with a WSON chip rather than SOIC. You will likely have to solder
             a new chip. High difficulty. Also a slow machine.

**T400s**    Same as the X200t, you have to replace the chip.
------------------------------------------------------------------------------------

In summary, I would stay away from any suffixed models.
The T400 is my personal favourite as it balances portability and performance with the quad mod.
The T400 is also portable enough to take to school or work, with decent battery life as well.
The X200 is just too small in my opinion.
If you're used to a contemporary 13" notebook then the tiny 12" display on the X200 will be jarring.
Combining the small size of the X200 with its measly performance and soldered CPU is why I would recommend giving it a pass.

## Non-Libreboot

The main reason someone might use a non-librebooted machine is that they are scared that a decade-old machine can't keep up with a modern workflow.
These concerns are generally unwarranted.
The machines from 2008 are more than capable of running a lite desktop environment or window manager with no noticeable performance issues.

Another reason someone might choose a newer model is that they aren't concerned with FOSS purism.
If all you want is customization, then coreboot with some binary blobs and a stripped *IME* is probably fine.
I'm fairly amenable to this point of view, but there are some things to consider.
As Richard Stallman is apt to point out, **any** proprietary code could be a malicious backdoor.

> "95% free software is like a girlfriend who is 95% AIDS-free"
>
> [**- Luke Smith**](https://www.youtube.com/watch?v=f5UEuWMlqRI)  *(paraphrased)*

The highest specd machine I can recommend in this category is the T440P.
The T440P looks like a modern laptop and is reasonably portable.
The machine is also the last machine you can get that has a socketed CPU, which is a must for user freedom.
You should note however, that this machine has the "new" crappy chiclet keyboard.
The keyboard is still better than any other chiclet keyboard I've used, but nothing compares to a classic keyboard.
For reference, the '200 series machines are the last to have the excellent classic keyboard.

Another popular choice for non-librebootable thinkpad is the X220.
That machine is the last X series thinkpad with a classic keyboard.
That being said, you can still install the classic keyboard in any '300 series thinkpad.

Qubes OS is an important factor to mention in this guide.
I don't personally think it's all it's cracked up to be, but it's quite popular.
No librebootabl thinkpad will work with Qubes.
Qubes needs a CPU with virtualization support, which requires an I-series processor.

If you want Qubes and the best thinkpad benefits, then you should get a '300 series and instal a classic keyboard with coreboot+cleaned *IME.*
My personal choice in this category would be a T430.
In my opinion, the "classic" keyboard (from the '200 series) still is not as good as the '00 series keyboard; so take that as you will.
