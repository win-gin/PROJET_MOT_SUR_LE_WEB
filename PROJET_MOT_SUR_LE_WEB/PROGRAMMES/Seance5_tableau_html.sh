#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/CreationTableau_url_1colonne_html_test.sh
#testé avec ./URLS/liste-url-newspaper.txt fourni par le prof
#execute  
#bash ./PROGRAMMES/Seance5_parametres.sh < ./PROGRAMMES/Seance5_parametres.txt
#VERSION 20171018
#MISE A JOURS ; read from +files write into +files.html
################################################################
# seance 5 test  

parametre :  ./PROGRAMMES/Seance5_parametres.txt
################################################################
echo "Création d'une page html contenant une colonne d'urls";
read repertoire; 
echo "le nom du rep contenant des fichiers de liens urls : $rep"; 
read table;
echo "le nom du fichier html ou stocker les fichiers dans un tableau : $table"
echo '<!DOCTYPE html>' > $table;
echo '<html>' >> $table;
echo '<head>' >> $table;
#####################################################################################
#############echo -e "<html>\n<head>\n<title>\n</title>\n</head>\n<body>"> $table;
############[OPTION] -e de echo   permet l'interpretation de \########################
# l'encodage de caractères 

##########################################
##read chaque fichier dans un repertoire
#read fichier par fichier
#ecrit des urls de chaque fichier dans des tables differents dans un seul f.html
:'
for file in $(ls $repertoire)   #  $repertoire  le premier var dans le fichier para.txt 
    do  
        echo "<table>">>$tablo;
        for line in $(cat $rep/$file) 
            echo "<tr><td align = "center"><a href="$l">$l</a></td><tr>" >>$tablo; 
        done;
        echo "</table>" >>$tablo;
done;

##############################################
'
#########################################

##read chaque fichier dans un repertoire
#read fichier par fichier
#ecrit des urls de chaque fichier dans des tables differents dans un seul f.html
#table contains 2 cols
#counteur  iterateur

:'
#

for file in $(ls $repertoire)   #  $repertoire  le premier var dans le fichier para.txt 

    do  
        echo "<table>">>$tablo;
        compteur=0;
        for line in $(cat $rep/$file) 
            let compteur=compteur+1;
            echo "<tr><td>$compter</td><td align = "center"><a href="$l">$l</a></td><tr>" >>$tablo;
        done;
        
done;

echo "</table>" >>$tablo;
##############################################
'
######################################################
:'

sufra
3cols in a table
Nb, url, page_aspiree
#curl ++  sortie stdOUT par defaut  ,il faut rediriger 
# wget --  redirection par defaut dans le rep courant

#diff
##############################################
########  2 iterateurs  1 for table  1 for line
#counterline
#counter table
counter_table =0
for file in $(ls $repertoire)   #  $repertoire  le premier var dans le fichier para.txt 
     let compteur_table=compteur_table+1;

    do  
        echo "<table>">>$tablo;
        compteur=0;
        for line in $(cat $rep/$file) 
            let compteur=compteur+1;
            curl $line >> ./PAGE-ASPIREES/page$compteur.html
            echo "<tr><td>$compter</td><td align = "center"><a href="$l">$l</a></td><a href = "./PAGE-ASPIREES/page/$compteur_table_$compteur.html">pages aspirer</a></td><tr>" >>$tablo;
        done;        
done;
echo "</table>" >>$tablo;
###################################



###########################333######################



echo '<title>Tableau urls</title>' >> $table;
echo '<meta charset = "utf-8">' >> $table; 
echo '</head>' >> $table;
echo '<body>' >> $table;
echo '<p>Tableau des urls de teste<p>' >> $table;
echo '<table border = "1" bordercolor = "#47baae" width = "60%" align = "center">' >> $table;
echo '<tr>' >> $table;
echo '<th>liens</th>' >> $table;
echo '</tr>' >> $table;
#boucle d'insertion des liens ligne par ligne
############### add line number################
:'
numligne=0;
while read nom
    do
        let numligne=numligne+1;
            echo"<tr><td>$numligne</td><td>$nom</td></tr>" >> $tablo;
        done;
'
######################
#read plusieurs fichiers et wirte plusieurs fichiers
:'
 for file in $(ls ./URLS); do cat ./URLS/$file; done;

 ###
  for file in $(ls ./URLS); do cat ./URLS/$file; echo -e "\n\n\n"; done;
 ####

 
 cat 'Seance5_parametres.txt'|while 


'
###################

for l in $(cat $file);
#for l in 'cat $file';
do 
    echo "<tr><td align = "center"><a href="$l">$l</a></td><tr>" >> $table;
done;
echo '</table>' >> $table;
echo '</body>' >> $table;
echo '</html>' >> $table;
echo 'Fin de création de tableau.'


