scriptDownloadFreebox
=====================

SHELL> Un petit script permettant de lancer à distance, un téléchargement sur sa FreeBox v6 (firmware 1.1.9.1). 
Conçu pour fonctionner avec le système de sécurité CSRF

Versions des outils utilisés :
-FreeBox v6 (firmware 1.1.9.1)
-curl 7.21.0: libcurl/7.21.0 OpenSSL/0.9.8o zlib/1.2.3.4 libidn/1.15 libssh2/1.2.6

Configuration : Editez le scriptDownloadFreebox et modifiez les deux variables suivantes avec vos données:

- freeboxIpAddress='IP.IP.IP.IP'
- freeboxPasswd='motDePasse'

Utilisation : "bash scriptRenameFreebox \<lien http>"

=====================
Inspiré des scripts de Zakhar 
http://forum.ubuntu-fr.org/viewtopic.php?id=448343
