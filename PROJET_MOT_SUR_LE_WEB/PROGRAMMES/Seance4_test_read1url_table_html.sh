#!bin/bash
#CreationTableau_url_1colonne_html_test.sh
#/home/chunyang/Documents/ProjetEncadre20172018/PROJET_MOT_SUR_LE_WEB

# Création d'un page html contenant une colonne d'urls
# Entrée : un fichier .txt contenant des urls
# Sortie : un fichier .html contenant un tableau d'une colonne



 for line in $(cat ./URLS/seance4_test_liste.txt); 
do echo "<tr><td>$line</td><tr>"; 
done;