#!/bin/bash

maindir="$PWD"
for dir in $(ls -d */); do
 cd $maindir
 echo "converting files in $dir"
 cd "$maindir/${dir%?}"
for image in *_orig*; do
 echo "converting $image"
 convert $image -resize 640x480 "${image%_orig.*}.webp"
done
done
