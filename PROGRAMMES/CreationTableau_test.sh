#!/bin/sh
cd ../TABLEAUX;
read nom;
read sujet;
echo  '<!DOCTYPE html>' > Sujet.html;
echo  '<html>' >> Sujet.html;
echo  '<head>' >> Sujet.html;
echo  '<meta charset="UTF-8">' >> Sujet.html;
echo  "<title>$nom</title>" >> Sujet.html;
echo  '</head>' >> Sujet.html;
echo  '<body>' >> Sujet.html;
echo  "<h2 align = \"center\">Projet Encadre</h2>" >> Sujet.html;
echo  '<table border="1" align = "center" width = "60%">' >> Sujet.html;
echo  '<tr><td>XU Yizhou</td></tr>' >> Sujet.html;
echo  "<tr><td>$sujet</td></tr>" >> Sujet.html;
echo  '</table>' >> Sujet.html;
echo  '</body>' >> Sujet.html;
echo  '</html>' >> Sujet.html;