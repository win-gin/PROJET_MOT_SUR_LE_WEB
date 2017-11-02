#!/bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/Seance1025_CreationTableaux_v_3col.sh
#EXECUTION
#bash ./PROGRAMMES/Seance1025_CreationTableaux_v_3col.sh < ./PROGRAMMES/Seance1025_parametres
#VERSION 20171025
#MISE A JOURS :
#
################################################################
#parametre :  ./PROGRAMMES/Seance1025_parametres
################################################################
echo "Création de la page html";
read repertoire_urls;
read html_tableaux;
read repertoire_aspiree;
echo "INPUT : Le nom du repertoire contenant les fichiers d'url : $repertoire_urls"; 
echo "OUTPUT : Le nom du fichier html en sortie : $html_tableaux";
echo "OUTPUT : Le nom du répertoire stockant les pages aspirées : $repertoire_aspiree";

######debut de la page HTML finale ######
echo  '<!DOCTYPE html>' >$html_tableaux;
echo -e "<html>\n<head>\n\t<meta charset=\"utf8\">\n\t<title>Tableaux de liens</title>\n</head>\n<body>" >> $html_tableaux; 
echo -e "\t<h2 align = \"center\">Tableau de liens</h2>" >> $html_tableaux;


###### 2 iterateurs : 1 pour tableau (compteur_tableaux), 1 pour ligne (compteur_lien) ######
compteur_tableaux=1;
for fichier_url in `ls $repertoire_urls`     # la première boucle permettant de lire fichier par fichier et de créer n tableaux (n = le nombre de fichiers dans le répertoire ./URLS)
do
    #creation du tablaeu
    echo -e "\t<table border=\"1\" align=\"center\" width=\"66%\" bordercolor=\"#47baae\">" >> $html_tableaux;
    echo -e "\t\t<tr bgcolor=\"#47baae\"><th colspan=\"6\">\n\t\t\t$fichier_url</th></tr>" >> $html_tableaux;
    #tete de clonne numero
    echo -e "\t\t\t\t<th align=\"center\" width\"20%\">N°</th>" >> $html_tableaux;
    #code retourne
    echo -e "\t\t\t<th align=\"center\" width\"35%\">CODE URL</th>" >> $html_tableaux;
    #tete de colonne lien
    echo -e "\t\t\t<th align=\"center\" width=\"10%\" align=\"center\">LIEN</th>" >> $html_tableaux;
    #tete de colonne encodage
    echo -e "\t\t\t<th width=\"20%\" align=\"center\">ENCODAGE INITIAL</th>" >> $html_tableaux;
    #tete de colonne PA
    echo -e "\t\t\t<th align=\"center\" width=\"20%\">PAGES ASPIREES</th>" >> $html_tableaux;
    #tete de colonne DUMP
    echo -e "\t\t\t<th align=\"center\" width=\"20%\">DUMP UTF-8</th>\n\t\t</tr>" >> $html_tableaux;
    
    
    compteur_lien=1;
    for lien in `cat $repertoire_urls/$fichier_url`      # la seconde boucle permettant de traiter ligne par ligne des urls dans chaque fichier
    do
        curl $lien > $repertoire_aspiree/$compteur_tableaux-$compteur_lien.html;      # aspirer des pages html et les rédiriger dans le répertoire ./PAGE-ASPIREES
        lynx -dump -nolist $lien > ./DUMP-TEXT/$compteur_tableaux-$compteur_lien;
        ###### écrire ligne par ligne et colonne par colonne le numéro, l'url et le lien vers la page aspirée dans chaque tableau ######
        #colonne N°
        echo -e "\t\t<tr >\n\t\t\t<td align=\"center\">$compteur_lien</td>" >> $html_tableaux;
        #
        etat=$(curl -sI $lien | head -n 1)
        echo -e "\t\t\t<td>$etat</td>" >> $html_tableaux;
        #colonne Lien
        echo -e "\t\t\t<td align=\"center\"><a href="$lien">lien N°$compteur_lien</a></td>" >> $html_tableaux;
        #colonne de encodage initial
        encodage=$(curl -sI $lien | egrep -i "charset=" | cut -f2 -d= | tr -d "\n" | tr -d "\r" | tr "[:upper:]" "[:lower:]");
        echo -e "\t\t\t<td align=\"center\">$encodage</td>" >> $html_tableaux;
        #colonne Page Aspiree
        echo -e "\t\t\t<td align=\"center\"><a href=".$repertoire_aspiree/$compteur_tableaux-$compteur_lien.html">P.A N°$compteur_tableaux-$compteur_lien</a></td>" >> $html_tableaux;
        #colonne DUMP 
        echo -e "\t\t\t<th align=\"center\"><a href="../DUMP-TEXT/$compteur_tableaux-$compteur_lien">DUMP N°$compteur_tableaux-$compteur_lien</a></th>\n\t\t</tr>" >> $html_tableaux;
        
        let compteur_lien++;
    done    
    echo "</table>" >> $html_tableaux;
    echo -e "<hr width=\"66%\" size=\"6\" color=\"#47baae\"/>" >> $html_tableaux;    #horizontal rule
    let compteur_tableaux++;
done

###### fin de la page HTML finale ######
echo -e "</body>\n</html>" >> $html_tableaux;
echo "Fin de création des tableaux.";