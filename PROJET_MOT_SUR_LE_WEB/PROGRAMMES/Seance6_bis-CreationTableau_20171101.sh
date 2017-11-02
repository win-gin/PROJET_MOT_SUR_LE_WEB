#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/Seance6_bis-CreationTableau_7cols.sh
#PARAMETRE: ./PROGRAMMES/Seance6_bis_parametres
#EXECUTION
#bash ./PROGRAMMES/Seance6_bis-CreationTableau_7cols.sh < ./PROGRAMMES/Seance6_bis_parametres
#VERSION 20171025
#MISE A JOURS :
#   i ajouter la colonne Etat_de_lien (Réponse de requête)
#   ii ajouter la colonne Code_retour (le http_code de la Réponse de requête)
#   iii ajouter la colonne encodage (pour l'instant, ne récupérer que l'encodage
#       à partir de l'entête à l'aide de curl -I)
#   iv ajouter la colonne Dump-text
#   v suprimer le table_iterator ; pour remplacer, lire le nom du fichier d'URLs
#   vi ajouter une paramètre rep_dump_text pour stocker des texts dump
###############################################################################
###############################################################################
###############lire des paramètres dans le fichier Seance6_parametres##########
echo "Création d'une page html contenant trois tableaux ";
read rep; 
read table;
read rep_page_aspiree;
read rep_dump_text;

echo "INPUT : nom du répertoire contenant des fichiers d'URLs : $rep"; 
echo "OUTPUT : nom du fichier html contenant des tableaux : $table";
echo "OUTPUT : nom du répertoire stockant les pages aspirées : $rep_page_aspiree";
echo "OUTPUT : nom du répertoire stockant les texts dump : $rep_dump_text";

echo -e "\n\n\n\n\nVeuillez patienter quelques instants.\n\n\nTravail en mode silence...\n\n\n";

################################################################################

echo -e "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>Tableau URLs</title>\n\t\t<meta charset = 'utf-8'>\n\t</head>\n" > $table;
echo -e "\t<body>\n\t\t<h2 align=\"center\">Tableaux des URLs de teste</h2>" >> $table;

###############################2 iterateurs,1 pour tableau, 1 pour ligne########
#table_iterator=0;

#La première boucle permettant de lire fichier par fichier et de créer n 
#tableaux (n = le nombre de fichiers dans le répertoire ./URLS)
for file in `ls $rep`
do  
    #let "table_iterator = table_iterator++";
    echo -e "\t\t<table border = \"1\" bordercolor = \"#47baae\" width = \"80%\" align = \"center\">" >> $table;
    echo -e "\t\t\t<tr height = \"30px\" bgcolor = \"#47baae\"><th colspan = \"7\">Tableau-$file</th></tr>" >> $table;
    echo -e "\t\t\t<tr>\n\t\t\t<th width = \"5%\" align = \"center\">N°</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"20%\" align = \"center\">Etat_de_lien</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Code_retour</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Encodage</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Lien</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Page_aspirée</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Dump-text</th>\n\t\t\t</tr>" >> $table;
    
    line_iterator=0;
    # la seconde boucle permettant de traiter ligne par ligne des urls  dans chaque fichier
    for line in `cat $rep/$file`
    do
        let line_iterator++;
        #2 variables, 1 pour la page aspirée, 1 pour le text dump
        page="$rep_page_aspiree/$file-aspiree-bis-$line_iterator.html";
        dump="$rep_dump_text/$file-dump-bis-$line_iterator";
        
        #Demande la réponse de requête,  [OPTION]de cURL -s: en mode silence;  
        #-I:récupérer seulement l'entête info de HTTP; -L: relancer la requête de curl 
        #en cas de rédirections; le motif 'HTTP\/[0-9]\.[0-9]'correspond aux protocaux 
        #HTTP/0.9 HTTP/1.1 HTTP/2.0 etc.
        #awk '{print $2}  imprimer la deuxième "colonne" dans une ligne du type suivant : HTTP/1.1 200 OK, ie. le http_code
        # sed 's/\n/\t/g' et 's/\r/\t/g' remplacer des passages à la lignes par une tabulation pour que plusieurs valeurs soient dans la même ligne
        lien_statut=`curl -sIL $line|egrep -i 'HTTP\/[0-9]\.[0-9]'| awk '{print $0}' | sed  's/\n/\t/g'|sed  's/\r/\t/g'`; 
        
        #Demander le http_code (une autre manière que la RegExp utilisée supra),
        #aspirer la page html et la rédiriger avec le nom $page
        code_retour=`curl -sL -o $page -w "%{http_code}" $line`;
        echo "Etat de lien : $lien_statut"; #test, à enlever après
        echo "Code_retour : $code_retour"; #test, à enlever après
       # echo "################################################################";
        
        #Demander l'encodage  
        #RegExp: ?<=   lookbehind;  ?=  lookahead
        #$0 : l'ensemble de la ligne qui correspond à l'argument grep;
        #tolower() transmettre en miniscule
        #alternative: démimiter par  =
        #encodage=`curl -sIL $line |egrep -i "charset"|cut -d"=" -f2`;
        #encodage=`curl -sIL $line|grep -i -Po '(?<=charset=).+(?=\b)' |awk '{print tolower($0)}'|sed 's/\"//g'`;
        
        #alternative : ne chercher que l'encodage dans la page aspirée. 
        encodage_header_curl=`curl -sIL $line|grep -i -Po '(?<=charset=).+(?=\b)' |awk '{print tolower($0)}'`;
        echo "encodage header curl from remote page : $encodage_header_curl";
        encodage_curl=`curl -sL $line|egrep -i 'meta.+charset' |awk '{print tolower($0)}'|egrep -o "charset[=\s\"a-Z0-9\-]*" |cut -d"=" -f2 | sed  's/\s//g'|sed 's/\"//g'`;
        echo "encodage curl from remote page : $encodage_curl";
        
        encodage=`egrep -i 'meta.+charset' $page |awk '{print tolower($0)}'|egrep -o "charset[=\s\"a-Z0-9\-]*" |cut -d"=" -f2 | sed  's/\s//g'|sed 's/\"//g'`;
        echo "encodage in local page meta tag : $encodage";
        
        encodage_cmd_file=`file -i $page`;
        echo "encodage de local page interprete par cmd file : $encodage_cmd_file";
        
        encodage_cmd_enca=`enca -L none $page`;
        echo "encodage_cmd_enca de local page : $encodage_cmd_enca";
        
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
        
        #Récupérer le text, ingnorer des urls dans la page
        lynx -dump -nolist $line > $dump;
        
        
        echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table;
        echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
        echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
        echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
        echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>$file-lien-$line_iterator</a></td>" >> $table;
        echo -e "\t\t\t\t<td align = \"center\"><a href = ".$page">$file-aspiree-$line_iterator</a></td>" >> $table;
        echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump">$file-dump-$line_iterator</a></td>\n\t\t\t</tr>" >> $table;
    done;
    
    echo -e "\t\t</table>\n" >> $table;
    echo -e "\t\t<br/>\n\t\t<hr width = \"80%\" color = \"#47baae\" cb 9 size = \"10\">\n\t\t<br/>" >> $table; #horizontal rule
done;

echo -e "\t</body>\n</html>" >> $table;
echo "Fin de création des tableaux.";




