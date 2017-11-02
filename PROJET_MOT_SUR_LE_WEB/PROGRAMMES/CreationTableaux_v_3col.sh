#!/bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/CreationTableaux_v_3col.sh
#EXECUTION
#bash ./PROGRAMMES/CreationTableaux_v_3col.sh < ./PROGRAMMES/parametres
#VERSION 20171018
#MISE A JOURS :
#   i.      lire plusieurs fichiers d'urls
#   ii.     stocker les urls dans des tableaux différents  
#   iii.    ajouter deux nouvelles colonnes (numéro et page_aspirée)
#   iv.     ajouter un paramètre pour stocker des pages aspirées
################################################################
#parametre :  ./PROGRAMMES/parametres
################################################################
echo "Création d'une page html contenant trois colonnes";
read repertoire;
read nom_html;
read repertoire_aspiree;
echo "INPUT : Le nom du repertoire contenant les fichiers d'url : $repertoire"; 
echo "OUTPUT : Le nom du fichier html en sortie : $nom_html";
echo "OUTPUT : Le nom du répertoire stockant les pages aspirées : $repertoire_aspiree";

######debut de la page HTML finale ######
echo  '<!DOCTYPE html>' >$nom_html;
echo -e "<html>\n<head>\n\t<meta charset=\"utf8\">\n\t<title>Tableaux de liens</title>\n</head>\n<body>" >> $nom_html; 
echo -e "\t<h2 align = \"center\">Tableau de liens</h2>" >> $nom_html;


###### 2 iterateurs : 1 pour tableau (compteur_tableaux), 1 pour ligne (compteur_lien) ######
compteur_tableaux=1;
for fichier_url in `ls $repertoire`     # la première boucle permettant de lire fichier par fichier et de créer n tableaux (n = le nombre de fichiers dans le répertoire ./URLS)
do
    echo -e "\t<table border=\"1\" align=\"center\" width=\"66%\" bordercolor=\"#47baae\">" >> $nom_html;
    echo -e "\t\t<tr bgcolor=\"#47baae\"><th colspan=\"3\">\n\t\t\t$fichier_url</th></tr>" >> $nom_html;
    echo -e "\t\t<tr>\n\t\t\t<th align=\"center\" width\"10%\">N°</th>" >> $nom_html;
    echo -e "\t\t\t<th width=\"80%\" align=\"center\">Lien</a></th>" >> $nom_html;
    echo -e "\t\t\t<th align=\"center\">Page Aspirée</th>\n\t\t</tr>" >> $nom_html;
    
    compteur_lien=1;
    for lien in `cat $repertoire/$fichier_url`      # la seconde boucle permettant de traiter ligne par ligne des urls dans chaque fichier
    do
        curl $lien > $repertoire_aspiree/$compteur_tableaux-$compteur_lien.html;      # aspirer des pages html et les rédiriger dans le répertoire ./PAGE-ASPIREES
        ###### écrire ligne par ligne et colonne par colonne le numéro, l'url et le lien vers la page aspirée dans chaque tableau ######
        echo -e "\t\t<tr >\n\t\t\t<td align=\"center\">$compteur_lien</td>" >> $nom_html;
        echo -e "\t\t\t<td><a href="$lien">$lien</a></td>" >> $nom_html;
        echo -e "\t\t\t<td align=\"center\"><a href=".$repertoire_aspiree/$compteur_tableaux-$compteur_lien.html">$compteur_tableaux-$compteur_lien</a></td>\n\t\t</tr>\n" >> $nom_html;
        let compteur_lien++;
    done    
    echo "</table>" >> $nom_html;
    echo -e "<hr width=\"66%\" size=\"6\" color=\"#47baae\"/>" >> $nom_html;    #horizontal rule
    let compteur_tableaux++;
done

###### fin de la page HTML finale ######
echo -e "</body>\n</html>" >> $nom_html;
echo "Fin de création des tableaux.";