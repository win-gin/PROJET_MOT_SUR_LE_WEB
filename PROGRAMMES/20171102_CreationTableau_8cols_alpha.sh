#!bin/bash
#PATH=$PATH:~/home/.../PROJET_MOT_SUR_LE_WEB
#./PROGRAMMES/20171102_CreationTableau.sh
#parametre :  ./PROGRAMMES/20171102_parametres
#EXECUTION
#bash ./PROGRAMMES/20171102_CreationTableau_8cols_alpha.sh < ./PROGRAMMES/20171102_parametres
#VERSION 20171102
################################################################################
#MISE A JOUR :
#i Ajouter des structures de contrôle
#ii Etre capable de récupérer des encodages qui ne sont pas parus dans l'entête par la rếponse de curl -IL
#   (chercher dans la balise meta de fichier html)
#iii Etre capable de convertir tous les textes non-utf8 en utf8 à l'aide de commandes enca et iconv 
#iv Ajouter la colonne Dump_utf8 pour montrer tous les texts en utf8
#v Modifier la colonne Dump comme Dump initial, pour montrer uniquement des textes non-utf8
#vi Modifier la colonne encodage comme encodage initial, pour montrer l'encodage des fichiers non-utf8
################################################################################

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


for file in `ls $rep`
{  
    #let "table_iterator = table_iterator++";
    echo -e "\t\t<table border = \"1\" bordercolor = \"#47baae\" width = \"80%\" align = \"center\">" >> $table;
    echo -e "\t\t\t<tr height = \"30px\" bgcolor = \"#47baae\"><th colspan = \"8\">Tableau-$file</th></tr>" >> $table;
    echo -e "\t\t\t<tr>\n\t\t\t<th width = \"3%\" align = \"center\">N°</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"7%\" align = \"center\">Code_retour</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Etat_de_lien</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Lien</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Page_aspirée</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Encodage_initial</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Dump_initial</th>" >> $table;
    echo -e "\t\t\t\t<th width = \"15%\" align = \"center\">Dump-utf8</th>\n\t\t\t</tr>" >> $table;
    
    line_iterator=0;
    for line in `cat $rep/$file`
    
        {
        let line_iterator++;
        #2 variables, 1 pour la page aspirée, 1 pour le text dump
        page="$rep_page_aspiree/20171102-$file-aspiree-$line_iterator.html";
        dump="$rep_dump_text/20171102-$file-dump-$line_iterator";
        
        #Demande la réponse de requête,  [OPTION]de cURL -s: en mode silence;  
        #-I:récupérer seulement l'entête info de HTTP; -L: relancer la requête de curl 
        #en cas de rédirections; le motif 'HTTP\/[0-9]\.[0-9]'correspond aux protocaux 
        #HTTP/0.9 HTTP/1.1 HTTP/2.0 etc.
        #awk '{print $2}  imprimer la deuxième "colonne" dans une ligne du type suivant : HTTP/1.1 200 OK, ie. le http_code
        # sed 's/\n/\t/g' et 's/\r/\t/g' remplacer des passages à la ligne par une tabulation pour que plusieurs valeurs soient dans la même ligne
        lien_statut=`curl -sIL $line|egrep -i 'HTTP\/[0-9]\.[0-9]'| awk '{print $0}' | sed  's/\n/\t/g'|sed  's/\r/\t/g'`; 
        
        #Demander le http_code (et supprimer des passages à la ligne),
        #aspirer la page html et la rédiriger avec le nom $page
        code_retour=`curl -sL -o $page -w "%{http_code}" $line | sed  's/\n//g'|sed  's/\r//g'`;
        echo "Etat de lien : $lien_statut"; #test, à enlever après
        echo "Code_retour : $code_retour"; #test, à enlever après
       # echo "################################################################";
       #condition code_retour == 200,  => verifier $encodage 
        if [[ $code_retour == 200 ]] ;then
            #Demander l'encodage
            #encodage_header_curl
            encodage=`curl -sIL $line|grep -i -Po '(?<=charset=).+(?=\b)' |awk '{print tolower($0)}'`;
            echo "encodage récupéré de l'entête : $encodage"; #test, à enlever après
            
            #condition $encodage == utf8, => dump
            if [[ $encodage == "utf-8" ]] ;then 
                #il faut désignier le jeu de caractères pour la commande lynx car quelques fois lynx ne peux pas réussir à décharger des textes sans connaissances d'encodages préalables   
                lynx -dump -nolist -assume_charset=%{charset} -display_charset=$encodage $line > $dump-utf8;
                echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                echo -e "\t\t\t\t<td align = \"center\"><a href = ".$page">20171102-$file-aspiree-$line_iterator</a></td>" >> $table;
                echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-utf8">20171102-$file-dump-$line_iterator-utf8</a></td>\n\t\t\t</tr>" >> $table;
                
            #condition non-utf8 && non vide => vérifier l'existence de $encodage dans la liste d'iconv
            elif [[ $encodage != "utf-8" ]] && [[ $encodage != "" ]] ;then
                #chercher l'encodage dans la liste des encodages de iconv
                verification_iconv=`iconv -l | egrep -io $encodage | sort -u`;
                
                # condition $encodage connu par iconv => dump et convertir en utf8
                if [[ $verification_iconv != "" ]] ; then
                    lynx -dump -nolist -assume_charset=%{charset} -display_charset=$encodage $line > $dump-$encodage;
                    #transformer l'encodage de texte déchargé vers utf8 par la commande iconv
                    # [OPTION] -f, from (de tel encodage); -t to (à tel encodage)
                    iconv -f $encodage -t utf-8 $dump-$encodage > $dump-utf8;
                    echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                    echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = ".$page">20171102-$file-aspiree-$line_iterator</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-$encodage">20171102-$file-dump-$line_iterator-$encodage</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-utf8">20171102-$file-dump-$line_iterator-utf8</a></td>\n\t\t\t</tr>" >> $table;
                    
                #condition $encodage non connu par iconv => rien à faire, seulement remplir les tableaux avec des infos necessaires
                else
                    echo "Echec : $encodage inconnu...";
                    echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                    echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">null</td>\n\t\t\t</tr>" >> $table;
                fi
                
            # condition pas de $encodage dans la réponse de curl -I, récupérer $encodage directement dans la balise meta de la page html (locale)
            elif [[ $encodage == "" ]] ;then
                encodage=`egrep -i 'meta.+charset' $page |awk '{print tolower($0)}'|egrep -o "charset[=\s\"a-Z0-9\-]*" |cut -d"=" -f2 | sed  's/\s//g'|sed 's/\"//g'`;
                #condition $encodage utf8 dump
                echo "encodage récupéré de page html : $encodage"; 
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
                
                if [[ $encodage == "utf-8" ]] ;then 
                    lynx -dump -nolist -assume_charset=%{charset} -display_charset=$encodage $line > $dump-utf8;
                    echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                    echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = ".$page">20171102-$file-aspiree-$line_iterator</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-utf8">20171102-$file-dump-$line_iterator-utf8</a></td>\n\t\t\t</tr>" >> $table;
                    
                #condition non-utf8 && non vide => dump
                elif [[ $encodage != "utf-8" ]] && [[ $encodage != "" ]] ;then
                    
                    lynx -dump -nolist -assume_charset=%{charset} -display_charset=$encodage $line > $dump-$encodage;
#                   #condition fichier d'URLS est en chinois, utiliser enca pour convertir (enca fonctionne mieux que iconv lors de traitement de fichier chinois)
                    if [[ "$file" == "CN*" ]] ;then
                        #transformer l'encodage de texte déchargé vers utf8 par la commande enca
                        #il faut désignier la langue de fichier, ie zh_CN pour le chinois
                        enca -L zh_CN utf-8 -x < $dump-$encodage > $dump-utf8;
                        echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                        echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\"><a href = ".$page">20171102-$file-aspiree-$line_iterator</a></td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-$encodage">20171102-$file-dump-$line_iterator-$encodage</a></td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-utf8">20171102-$file-dump-$line_iterator-utf8</a></td>\n\t\t\t</tr>" >> $table;
                    # condition pour les autres fichiers, vérifier l'encodage à l'aide de liste des encodages de iconv puis décharger 
                    
                    else
                        verification_iconv=`iconv -l | egrep -io $encodage | sort -u`;
                        
                        if [[ $verification_iconv != "" ]] ; then
                            lynx -dump -nolist -assume_charset=%{charset} -display_charset=$encodage $line > $dump-$encodage;
                            iconv -f $encodage -t utf-8 $dump-$encodage > $dump-utf8;
                            echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                            echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\"><a href = ".$page">20171102-$file-aspiree-$line_iterator</a></td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-$encodage">20171102-$file-dump-$line_iterator-$encodage</a></td>" >> $table;
                        echo -e "\t\t\t\t<td align = \"center\"><a href = ".$dump-utf8">20171102-$file-dump-$line_iterator-utf8</a></td>\n\t\t\t</tr>" >> $table;
                        
                        else
                            echo "Echec : $encodage inconnu...";
                            echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                            echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                            echo -e "\t\t\t\t<td align = \"center\">null</td>\n\t\t\t</tr>" >> $table;
                        fi
                    fi
                    
                else 
                    echo "Echec : $encodage inconnu...";
                    echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
                    echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">-</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">$encodage</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
                    echo -e "\t\t\t\t<td align = \"center\">null</td>\n\t\t\t</tr>" >> $table;
                fi                    
            fi
            
        else
            # condition état de lien autre que 200, rien à faire, seulement imprimer son numéro, son code_retour, son état et son lien.
            echo "Echec : $lien_statut";
            echo -e "\t\t\t<tr>\n\t\t\t\t<td align = \"center\">$line_iterator</td>" >> $table; 
            echo -e "\t\t\t\t<td align = \"center\">$code_retour</td>" >> $table;
            echo -e "\t\t\t\t<td align = \"center\">$lien_statut</td>" >> $table;
            echo -e "\t\t\t\t<td align = \"center\"><a href = '$line'>20171102-$file-lien-$line_iterator</a></td>" >> $table;
            echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
            echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
            echo -e "\t\t\t\t<td align = \"center\">null</td>" >> $table;
            echo -e "\t\t\t\t<td align = \"center\">null</td>\n\t\t\t</tr>" >> $table;
        fi
        }
    
    echo -e "\t\t</table>\n" >> $table;
    echo -e "\t\t<br/>\n\t\t<hr width = \"80%\" color = \"#47baae\" cb 9 size = \"10\">\n\t\t<br/>" >> $table; #horizontal rule
}

echo -e "\t</body>\n</html>" >> $table;
echo "Fin de création des tableaux.";




