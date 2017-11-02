#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/Seance6-CreationTableau_7cols.sh
#EXECUTION
#bash ./PROGRAMMES/Seance6-CreationTableau_7cols.sh < ./PROGRAMMES/Seance6_parametres
#VERSION 20171025
#MISE A JOURS :
#   i ajouter la colonne Etat_de_lien (Réponse de requête)
#   ii ajouter la colonne Code_retour (le http_code de la Réponse de requête)
#   ii ajouter la colonne encodage (pour l'instant, ne récupérer que l'encodage à partir)
#   iii suprimer le compteur table en ajoutant lire le nom du fichier d'url et l'affacter a
################################################################
#parametre :  ./PROGRAMMES/Seance6_parametres
################################################################
echo "Création d'une page html contenant trois tableaux ";
read rep; 
read table;
read rep_page_aspiree;
read rep_dump_text;
echo "INPUT nom du répertoire contenant des fichiers d'URLs : $rep"; 
echo "OUTPUT nom du fichier html contenant des tableaux : $table";
echo "OUTPUT nom du répertoire où stocker les pages aspirées : $rep_page_aspiree";
echo "OUTPUT nom du répertoire où stocker les texts dump : $rep_dump_text";
echo -e "\n\n\n\n\nVeuillez patienter quelques instants.\n\n\nTravail en mode silence.\n\n\n";

###########################################################################################################
echo -e "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>Tableau urls</title>\n\t\t<meta charset = 'utf-8'>\n\t</head>\n\n<body>\n\t<p>Tableaux des urls de teste<p>\n" > $table;

###############################2 iterateurs,1 pour tableau, 1 pour ligne###################################
#table_iterator=0;
for file in `ls $rep`   #  le 1er boucle qui permet de lire fichier par fichier et de créer n tableaux (n = le nombre de fichiers dans le répertoire ./URLS) 
do  
    #let "table_iterator = table_iterator++";
    echo -e "\t<table border = 1 bordercolor = #47baae width = \"80%\" align = \"center\">" >> $table;
    echo -e "\t\t<tr height=\"30px\" bgcolor=\"#47baae\"><th colspan=\"7\">\n\t\t\tTableau-$file</th></tr>" >> $table;
    echo -e "\t\t<tr><th width = \"5%\" align = \"center\">N°</th><th width = \"20%\" align = \"center\">Etat_de_lien</th><th width = \"15%\" align = \"center\">Code_retour</th><th width = \"15%\" align = \"center\">Encodage</th><th width = \"15%\" align = \"center\">Lien</th><th width = \"15%\" align = \"center\">Page_aspirée</th><th width = \"15%\" align = \"center\">Dump-text</th></tr>" >> $table;
    line_iterator=0;
    for line in `cat $rep/$file` #  le 2nd boucle qui permet de traiter ligne par ligne des urls dans chaque fichier
    do
        let line_iterator++;
        page="$rep_page_aspiree/$file-aspiree-$line_iterator";
        dump="$rep_dump_text/$file-dump-$line_iterator";
        #pour s'assurer si curl se passe bien  ajouter une comande echo $?
        #curl -sL $line > $page; #aspirer des pages html et les rédiriger dans le répertoire ./PAGE-ASPIREES
        lien_statut=`curl -sIL $line|egrep -i 'HTTP\/[0-9]\.[0-9]'| awk '{print $0}'`;
        code_retour=`curl -sL -o $page -w "%{http_code}" $line`;
        echo "Etat de lien : $lien_statut";
        echo "code_retour : $code_retour";
        echo "###########################################################################";
        #head_info=`curl -sIL $line;
       # lien_statut=`curl -sL -o $page $line|egrep -i 'HTTP\/[0-9]\.[0-9]'| awk '{print $0}'`; #attention aux espaces! pas d'espaces  #statut du lien, y compris le http_code
        #code_retour=`awk '{print tolower($2)}' $lien_statut`; #http_code
        #get le http_code   :  200  #awk '{print tolower($1)}' 
        #statut=`grep -i HTTP/ $head | awk {'print $2'}`;#get le http_code   :  200 
        #encodage=`curl -sIL $line |egrep -i "charset"|cut -d"=" -f2`;   #si lencodage est utf8 on fait ca on dump, si non
        #encodage=`egrep -i "charset" $head |cut -d"=" -f2`;
        encodage=`curl -sIL $line|grep -i -Po '(?<=charset=).+(?=\b)'| awk '{print tolower($0)}'`;#obtenir la derniere colonne, ie l'encodage et les transmettre en miniscule
        
        lynx -dump -nolist $line>$dump; ##recuperer txt 
        echo -e "\t\t<tr>\n\t\t\t<td align = \"center\">$line_iterator</td>\n\t\t\t<td align = \"center\">$lien_statut</td>\n\t\t\t<td align = \"center\">$code_retour</td>\n\t\t\t<td align = \"center\">$encodage</td>\n\t\t\t<td align = \"center\"><a href="$line">$file-lien-$line_iterator</a></td>\n\t\t\t<td align = \"center\"><a href = ".$page">$file-aspiree-$line_iterator</a></td>\n\t\t\t<td align = \"center\"><a href = ".$dump">$file-dump-$line_iterator</a></td>\n\t\t</tr>" >>$table;#écrire ligne par ligne et colonne par colonne le numéro, l'url et le lien vers la page aspirée dans chaque tableau
    done;
    echo -e "\t<HR style= \" FILTER: alpha (opacity = 100, finishopacity = 0 , style= 2 )\" width = \"80%\" color = #47baae cb 9 SIZE = 10>" >> $table; #horizontal rule
    echo -e "\t</table><br/><br/>" >> $table;
done; 
echo -e "</body>\n</html>" >> $table;
echo "Fin de création des tableaux.";




