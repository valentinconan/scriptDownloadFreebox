#! /bin/bash
#
# @uthor : valentinconan
#
# https://github.com/valentinconan/scriptDownloadFreebox
#

freeboxIpAddress='IP.IP.IP.IP'
freeboxPasswd='motDePasse' 
#Pour les caracteres speciaux, comme un & par exemple, mettre la valeur hexadecimale ASCII, soit %26

#URL EN ARGUMENT OU DEMANDE D'URL
echo -ne "\nVerification de l'URL"
if [ -z "$1" ]; then
   echo -e "\t\t\t\t<ERREUR>"
   echo -e "\nUSAGE\nbash scriptFreeSeedBox <http://linkToDownload.com/file.txt>"
   exit 1
else
   echo -e "\t\t\t\t<  OK  >"
   url=$1
fi


#CONNEXION A LA FREEBOX
echo -ne "\nConnexion a la FreeBox"
resultCurl=$( mktemp )
curl -S -d "login=freebox&passwd=$freeboxPasswd" http://$freeboxIpAddress/login.php -v > $resultCurl 2>&1 
if grep -q "Set-Cookie:" $resultCurl; then
    echo -e "\t\t\t\t<  OK  >"
else
    echo -e "\t\t\t\t<ERREUR>"
    echo -e "\nImpossible de joindre la FreeBox ou mot de passe incorrect.\nUtilisez 'ping $freeboxIpAddress' pour tester la connexion.\n"
    rm $resultCurl > /dev/null 2>&1
    exit 1
fi
csrfToken=`grep "X-FBX-CSRF-Token" $resultCurl | cut -f 3 -d ' ' | sed "s/\r//"  `
fbxSid=`grep "FBXSID" $resultCurl | cut -f 3 -d ' ' | sed "s/FBXSID=//" | sed "s/;//" | sed "s/\r//" `

#AJOUT DU TELECHARGEMENT A LA FREEBOX
echo -en "\nAjout du 'Direct Download' sur la FreeBox"
curl -s -b FBXSID=$fbxSid -D - -o /dev/null -e http://$freeboxIpAddress/download.php http://$freeboxIpAddress/download.cgi --data-urlencode "csrf_token=$csrfToken" -d "url=$url&method=download.http_add" -H "X-Requested-With: XMLHttpRequest" -H "Accept: application/json, text/javascript, */*" > $resultCurl 2>&1
if grep -q "HTTP/1.1 200 OK" $resultCurl; then
    echo -e "\t\t<  OK  >"
else
    echo -e "\t\t<ERREUR>"
    echo -e "\nImpossible d'ajouter ce telechargement, valider la source du telechargement.\nConnectez-vous sur 'http://$freeboxIpAddress/download.php'\npour voir si vous ne l'avez pas deja telecharge.\n"
    rm $resultCurl > /dev/null 2>&1
    exit 2
fi

#DECONNECTION DE LA FREEBOX
echo -e "\nDeconnexion de la FreeBox\t\t\t<  OK  >\n"
rm $resultCurl > /dev/null 2>&1

exit 0
