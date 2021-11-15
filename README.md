# Thonkpeasant.xyz

This is the git repo for my [website.](thonkpeasant.xyz)
The files for individual pages are in the `markdown` directory.
The main site generator makefile is based on [pdsite.](https://github.com/GordStephen/pdsite)
There are three additional scripts I wrote for various tasks.

+ makeindex.sh: creates the index of pages which are seen by clicking on the navbar header.
+ makeyaml.sh: creates the yaml metadata used by pandoc for the conversion.
+ assets/makesmall.sh creates a 640x480 version of every image in assets using imagemagick. The actual pixel size is determined by the aspect ratio of the image.
