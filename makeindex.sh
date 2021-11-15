#!/bin/bash

ignore=("resources store contact")

Gettree(){
tree -f -I 'index.md' --noreport */ | awk -F '[ /]' '{gsub("[─└├│]",""); v=$0; if (!($1 ~ /^[A-z]/)) print $1 "+ " $v; else print  "#" $1}'
}

Getabstract(){
 abstract=$(sed -n '/---/,/\.\.\./{//!p;}' "$relpath" | awk '/abstract:/ {$1=""; sub(/^[ \t]+/, ""); print $0}')
 if [ -n "$abstract" ]; then
  echo -e "$abstract"
 fi
}

Getname(){
sed -n '/---/,/\.\.\./{//!p;}' "$relpath" | awk '/title:/ {$1=""; sub(/^[ \t]+/, ""); print $0}'
}


Parsetree(){
nofirst=false
while read -r line ; do
 case $line in
  +*)
   relpath=$(echo "$line" | awk '{print $2}')
   fullpath="/$dir$relpath"
   fullpath="${fullpath%.md}.html"
   name=$(Getname)
   echo "<a href=$fullpath><div class=indexentry>"
   echo -e "**$name**\n"
   Getabstract
   echo -e '</div></a>'
   ;;
  \#*)
   title="${line#?}"
   $nofirst && echo "</div>"
   echo -e "<div class=indexcontainer><div class=indexheading>${title^}</div>"
   nofirst=true
   ;;
 esac
done
}

od="$PWD"
cd markdown
for dir in */ ; do
 echo "checking $dir"
if printf '%s\n' "${ignore[@]}" | grep -q "${dir%?}" ; then
 echo "skipping ignored dir $dir"
else
 cd $dir
 Gettree | Parsetree > index.md
 cat index.md
 cd ../
fi
done

cd $od
