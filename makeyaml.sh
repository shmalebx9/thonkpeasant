#!/bin/bash

ignore=(store resources contact)

for ignoredir in ${ignore[@]} ; do
 echo "ignoring $ignoredir"
 ignorestring+="! -path *$ignoredir* "
done

Make_navbar(){
echo "navbar:"
echo " - {name: Home, link: /index.html}"
for dir in $(find markdown -mindepth 1 -maxdepth 1 -type d $ignorestring -printf '%f\n') ; do
 echo " - {name: ${dir^}, link: /$dir}" 
done
echo " - {name: Contact, link: /contact}"
echo " - {name: Store, link: https://www.ebay.ca/sch/calagr93/m.html}"
}

Make_index(){
 cd markdown
 for dir in $(ls -d1 */) ; do
  #rm "$dir"index.md
  find $dir -type f -name '*.md' ! -name 'index*' | while read -r line ; do
  subdir=$(echo $line | awk -F '/' '{print $2}')
  page=$(echo $line | awk -F '/' '{print $3}')
  
 done
 done
}

rm .site.yml
Make_navbar >> .site.yml
Make_index >> .site.yml

