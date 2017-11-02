#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/Seance6-CreationTableau_3cols.sh
#EXECUTION
#bash ./PROGRAMMES/Seance6-CreationTableau_3cols.sh < ./PROGRAMMES/Seance6_parametres.txt
#VERSION 20171025
#MISE A JOURS :
#  i ajouter la colonne encodage
#  ii ajouter la colonne rep_dump_text
# iii 
################################################################
#parametre :  ./PROGRAMMES/Seance6_parametres.txt
################################################################
echo "Création d'une page html contenant trois colonnes";
read rep; 
echo "le nom du répertoire contenant des fichiers de liens urls : $rep"; 
read table;
echo "le nom du fichier html où stocker les fichiers dans des tableaux : $table";
read rep_page_aspiree;
echo "le nom du répertoire où stocker les pages aspirées : $rep_page_aspiree";
read rep_dump_text;
echo "le nom du répertoire où stocker les texts dump : $rep_dump_text";
echo -e "<!DOCTYPE html>\n<html>\n<head>\n<title>Tableau urls</title>\n<meta charset = 'utf-8'>\n</head>\n<body>\n<p>Tableau des urls de teste<p>" > $table;

###############################2 iterateurs,1 pour tableau, 1 pour ligne###################################
table_iterator=0;
for file in $(ls $rep)   #  le 1er boulce qui permet de lire fichier par fichier et de créer n tableaux (n = le nombre de fichiers dans le répertoire ./URLS) 
do  
    let "table_iterator = table_iterator++";
    echo -e "\t<table border = 1 bordercolor = #47baae width = \"80%\" align = \"center\">" >> $table;
    echo -e "\t\t<tr><th width = \"10%\" align = \"center\">Numéro</th><th width = \"10%\" align = \"center\">encodage</th><th width = \"40%\" align = \"center\">Liens</th><th width = \"20%\" align = \"center\">Pages aspirées</th><th width = \"20%\" align = \"center\">dump-text</th></tr>" >> $table;
    line_iterator=0;
    for line in $(cat $rep/$file) #  le 2nd boulce qui permet de traiter ligne par ligne des urls dans chaque fichier
    do
        let "line_iterator=line_iterator++";
        #pour s'assurer si curl se passe bien  ajouter une comande echo $?
        encodage=$(curl -sIL $line |egrep -i "charset"|cut -d"=" -f2);   #si lencodage est utf8 on fait ca on dump, si non 
        curl $line > $rep_page_aspiree/$table_iterator-$line_iterator.html; #aspirer des pages html et les rédiriger dans le répertoire ./PAGE-ASPIREES
        page="$rep_page_aspiree/$table_iterator-$line_iterator.html";
        lynx -dump -nolist $line >./DUMP-TEXT/$table_iterator-$line_iterator.txt; ##
        echo -e "\t\t<tr>\n\t\t\t<td align = \"center\">$line_iterator</td>\n\t\t\t<td align = \"center\">$encodage</td>\n\t\t\t<td align = \"center\"><a href="$line">$line</a></td>\n\t\t\t<td align = \"center\"><a href = ".$page">pages_aspirée-$table_iterator-$line_iterator</a></td>\n\t\t<tr><td align = \"center\"><a href = "../DUMP-TEXT/$table_iterator-$line_iterator.txt">dump-$table_iterator-$line_iterator</a></td>\n\t\t</tr>" >>$table;#écrire ligne par ligne et colonne par colonne le numéro, l'url et le lien vers la page aspirée dans chaque tableau
    done;
    echo -e "\t<HR style= \" FILTER: alpha (opacity = 100, finishopacity = 0 , style= 2 )\" width = \"80%\" color = #47baae cb 9 SIZE = 10>" >> $table; #horizontal rule
    echo -e "\t</table>" >> $table;
done; 
echo -e "</body>\n</html>" >> $table;
echo "Fin de création des tableaux.";




