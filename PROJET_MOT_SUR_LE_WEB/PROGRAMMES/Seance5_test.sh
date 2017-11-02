#!usr/bin/bash

########################recuperer ligne de txt et les stocker dans $mavar
cat liste-url-newspaper.txt 
mavar=$(cat liste-url-newspaper.txt)
echo $mavar 

###################  boulce  read and write line by line######
f="./liste-url-newspaper.txt"
cat $f  # IN line out, stdOUT separer par "\s" 

for l in $(cat $f);
do 
    echo "<tr><td align = "center"><a href="$l">$l</a></td><tr>" >> $t;
done;
###################################################################


