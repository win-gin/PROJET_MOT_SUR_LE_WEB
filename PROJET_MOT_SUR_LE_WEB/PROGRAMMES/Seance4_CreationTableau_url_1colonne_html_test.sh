#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/CreationTableau_url_1colonne_html_test.sh
#testé avec ./URLS/liste-url-newspaper.txt fourni par le prof
################################################################
# Création d'une page html contenant une colonne d'urls
# Entrée : un fichier .txt contenant des urls 
# Sortie : un fichier .html contenant un tableau d'une colonne
################################################################
echo "Création d'une page html contenant une colonne d'urls";
echo 'Entrez le nom du fichier.txt contenant des liens :'; 
read f; 
echo 'Entrez le nom du fichier.html pour stocker les liens : '; 
read t; 
echo '<!DOCTYPE html>' > $t;
echo '<html>' >> $t;
echo '<head>' >> $t;
# l'encodage de caractères 
echo '<title>Tableau urls</title>' >> $t;
echo '<meta charset = "utf-8">' >> $t; 
echo '</head>' >> $t;
echo '<body>' >> $t;
echo '<p>Tableau des urls de teste<p>' >> $t;
echo '<table border = "1" bordercolor = "#47baae" width = "60%" align = "center">' >> $t;
echo '<tr>' >> $t;
echo '<th>liens</th>' >> $t;
echo '</tr>' >> $t;
#boucle d'insertion des liens ligne par ligne
for l in $(cat $f);
do 
    echo "<tr><td align = "center"><a href="$l">$l</a></td><tr>" >> $t;
done;
echo '</table>' >> $t;
echo '</body>' >> $t;
echo '</html>' >> $t;
echo 'Fin de création de tableau.'


