# Thonkpeasant.xyz

This is the git repo for my [website.](thonkpeasant.xyz)
The files for individual pages are in the `markdown` directory.
The main site generator makefile is based on [pdsite.](https://github.com/GordStephen/pdsite)
There are three additional scripts I wrote for various tasks.

+ makeindex.sh: creates the index of pages which are seen by clicking on the navbar header.
+ makeyaml.sh: creates the yaml metadata used by pandoc for the conversion.
+ assets/makesmall.sh creates a 640x480 version of every image in assets using imagemagick. The actual pixel size is determined by the aspect ratio of the image.
+ lighty.lua is a pandoc filter which automatically applies to all images in the markdown documents; it does the following:
	+ finds all images in the markdown document
	+ substitutes the image (in pandoc AST) for a raw html string

The lighty.lua filter is a useful way to make images workable from markdown.
If you put any images in the markdown document, then they will be displayed on your site with [1337box.](https://vimuser.org/1337box.html)
Basically, when the image is clicked it will take up the whole screen until clicked again (simulating lightbox).
If there is another image in the same directory as the linked image, with the suffix '\_orig' then that image is displayed when the image is clicked.
For example, if you have *myphoto.png* and *myphoto_orig.png* and you link \!\[\]\(myphoto.png\) then the user will see *myphoto.png* until they click, at which point *myphoto_orig.png* will fill the screen.
