#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/CreationTableau_3cols.sh
#EXECUTION
#bash ./PROGRAMMES/CreationTableau_3cols.sh < ./PROGRAMMES/Seance5_parametres.txt
#VERSION 20171018
#MISE A JOURS :
#   i. lire plusieurs fichiers d'urls
#   ii. stocker les urls dans des tableaux différents  
#   iii. ajouter deux nouvelles colonnes (numéro et page_aspirée)
#   iv. ajouter un paramètre pour stocker des pages aspirées
################################################################
#parametre :  ./PROGRAMMES/Seance5_parametres.txt
################################################################
echo "Création d'une page html contenant trois colonnes";
read rep; 
echo "le nom du répertoire contenant des fichiers de liens urls : $rep"; 
read table;
echo "le nom du fichier html où stocker les fichiers dans des tableaux : $table"
read rep_page_aspiree;
echo "le nom du répertoire où stocker les pages aspirées : $rep_page_aspiree"
echo -e "<!DOCTYPE html>\n<html>\n<head>\n<title>Tableau urls</title>\n<meta charset = 'utf-8'>\n</head>\n<body>\n<p>Tableau des urls de teste<p>" > $table;

###############################2 iterateurs,1 pour tableau, 1 pour ligne###################################
table_iterator=0;
for file in $(ls $rep)   #  le 1er boulce qui permet de lire fichier par fichier et de créer n tableaux (n = le nombre de fichiers dans le répertoire ./URLS) 
do  
    let "table_iterator = table_iterator++";
    echo -e "\t<table border = 1 bordercolor = #47baae width = \"80%\" align = \"center\">" >> $table;
    echo -e "\t\t<tr><th width = \"10%\" align = \"center\">Numéro</th><th width = \"60%\" align = \"center\">Liens</th><th width = \"30%\" align = \"center\">Pages aspirées</th></tr>" >> $table;
    line_iterator=0;
    for line in $(cat $rep/$file) #  le 2nd boulce qui permet de traiter ligne par ligne des urls dans chaque fichier
    do
        let "line_iterator=line_iterator++";
        curl $line > $rep_page_aspiree/$table_iterator-$line_iterator.html; #aspirer des pages html et les rédiriger dans le répertoire ./PAGE-ASPIREES
        page="$rep_page_aspiree/$table_iterator-$line_iterator.html";
        echo -e "\t\t<tr>\n\t\t\t<td align = \"center\">$line_iterator</td>\n\t\t\t<td align = \"center\"><a href="$line">$line</a></td>\n\t\t\t<td align = \"center\"><a href = ".$page">pages_aspirée-$table_iterator-$line_iterator</a></td>\n\t\t<tr>" >>$table;#écrire ligne par ligne et colonne par colonne le numéro, l'url et le lien vers la page aspirée dans chaque tableau
    done;
    echo -e "\t<HR style= \" FILTER: alpha (opacity = 100, finishopacity = 0 , style= 2 )\" width = \"80%\" color = #47baae cb 9 SIZE = 10>" >> $table; #horizontal rule
    echo -e "\t</table>" >> $table;
done; 
echo -e "</body>\n</html>" >> $table;
echo "Fin de création des tableaux.";




