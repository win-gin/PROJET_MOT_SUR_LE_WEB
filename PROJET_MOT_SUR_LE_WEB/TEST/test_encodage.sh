#!bin/bash
#Ce script permet de tester (DE MANIÈRE RUSTIQUE) l'encodage d'URLs avec des méthodes et des outils divers,
#et de trouver une solution éventuelle pour la suite de notre travail
#Contexte: 3 types de problèmes survenus lors de création de tableaux html
#1)certains urls ne répondent pas leur encodage dans l'entête récupéré par curl -I (cf notre blog précédent) ;
#2)certains sites (notamment des sites chinois avec gbk/gb2312 comme encodage) ne peuvent pas être déchargés par lynx.
#3)pour un même url, l'encodage de son texte déchargé diffère celui de sa page aspirée.
#pour y résoudre, il faut comparer des méthodes et des outils
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB/TEST/
#TESTÉ avec 8 urls : 4 chinois dont 3 en utf-8 et 1 en gb2312; 4 français dont 3 en utf-8 et 1 en iso-8859-1
#


echo "###########################################################################";
echo "test encoding... ";
echo "###########################################################################";
file=./URLs_test; 
rep_page_aspiree=./PAGE;
rep_dump_text=./TXT;
rep_transforme=./Trans_TXT;
echo "INPUT : URLs dans le fichire $file";
echo "OUTPUT : pages aspirées dans le rep $rep_page_aspiree";
echo "OUTPUT : textes déchargés dans le rep $rep_dump_text";
echo "###########################################################################";

    line_iterator=0;
    for line in `cat $file`
    do
        let line_iterator++;
        page="$rep_page_aspiree/aspiree-$line_iterator.html";
        dump="$rep_dump_text/dump-$line_iterator";
        txt_trans="$rep_transforme/trans-$line_iterator";
        
        ################################################################################
        
        echo "$line_iterator   $line";
        
        #method 1 : récupérer directement dans l'entête en envoyant une demande curl -I (ce que nous avons utilisé dans le blog précédent)
        encodage_header_curl=`curl -sIL $line|grep -i -Po '(?<=charset=).+(?=\b)' |awk '{print tolower($0)}'`;
        echo "method 1: $encodage_header_curl  : =>  curl -I header info charset";
        
        
        #method 2 :trouver dans la page html la ligne contenant le balise meta et l'encodage, puis récupérer l'encodage dans le fichier aspiré; 
        #1) trouver la chaîne qui correspond au motif 'meta.+charset' en ignorant la case, cela spécifie l'encodage paru dans le balise meta; 
        #2) récupérer l'ensemble de cette ligne et la transformer au miniscule 
        #3) trouver l'occurrence du motif "charset[=\s\'\"a-Z0-9\-]*" (en considérant des espaces, des guillemets).
        #4) récupérer l'encodage qui est délimité par =
        #5) enlever des espaces\guillemets éventuelles
        encodage_curl_page=`curl -sL $line|egrep -i 'meta.+charset' |awk '{print tolower($0)}'|egrep -o "charset[=\s\"a-Z0-9\-]*" |cut -d"=" -f2 | sed  's/\s//g'|sed 's/\"//g'`;
        echo "method 2: $encodage_curl_page : =>  parsing la page html with meta tag ";
        
        #method 3 : en principe, est de même que method 2, seule différence : fouiller dans la page locale
        curl -sL $line > $page;
        encodage_local_page=`egrep -i 'meta.+charset' $page |awk '{print tolower($0)}'|egrep -o "charset[=\s\"a-Z0-9\-]*" |cut -d"=" -f2 | sed  's/\s//g'|sed 's/\"//g'`;
        echo "method 3 : $encodage_local_page  : => parsing local page with meta tag";
        
        #method 4 : tester l'encodage de page aspirée avec la cmd file -i  (file ne fonctionne uniquement avec des fichiers locals)
        encodage_cmd_file=`file -i $page`;
        echo "method 4 : $encodage_cmd_file : => encodage de page locale interprétée par cmd file : ";
        
        #!!!!!!!!
        #method 5 : tester avec la cmd enca (fixons la langue en chinois, qui est l'origine de la plupart des problèmes) 
        #(ie. pour l'instant, pas de structure de contrôle, on ignore des url en fr)
        encodage_cmd_enca=`enca -L zh_CN $page`;
        echo "method 5 : $encodage_cmd_enca : =>  encodage_cmd_enca de page locale";
        ########################################################################################
       
        #désigner l'encodage par $encodage_curl_page
        lynx -dump -nolist -assume_charset=%{charset} -display_charset=$encodage_curl_page $line > $dump;
        
        ########################################################################################
        #voir l'encodage de texte déchargé par la cmd file
        encodage_texte_dump=`file -i $dump`;
        echo "Dump text en : $encodage_texte_dump   =>  par cmd file  ";
        # convertir l'encodage de texte déchargé vers utf8 par la cmd iconv
        # alternative : enca / utrac, 
        #txt_trans=`iconv -f $encodage_curl_page -t utf-8 $dump`;
        # voir l'encodage de texte après être transformé
        #encodage_txt_trans=`file -i $txt_trans`;
        #echo "Texte transformé en : $encodage_txt_trans   =>  transformé par iconv, vu par file  ";
        
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
        
    done;
    