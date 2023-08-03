#!/usr/bin/env sh

ECHO="/bin/echo -e"

$ECHO "
================================================
#                                              #
#             NodeJS App Template              #
#                  \e[32m(CREATE)\e[0m                    #
#                                              #
================================================
"

$ECHO "The following actions require sudo user permissions.\n"

# Port Default
port=3000

# Dir Default
dir="/usr/local/hestia/data/templates/web/nginx"

# NodeJs App Folder
nodeFolder="nodeapp"

while getopts "p:d:f:" opt; do
  case $opt in
    p)
      port=$OPTARG
      ;;

    d)
      dir=$OPTARG
      ;;
    f)
      nodeFolder=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

fileName1="$dir/NodeJs-Port-$port.tpl"
fileName2="$dir/NodeJs-Port-$port.stpl"
fileName3="$dir/NodeJs-Port-$port.sh"

# Show the selected port
$ECHO "* Action for port: $port"
$ECHO "* Dir: $dir"

# Checking if the file exists
$ECHO "* Checking if the file exists"
if test -f $fileName1 || test -f $fileName2 || test -f $fileName3; then
    $ECHO "   - \e[31mThe file with the port $port is already use.\e[0m"
    exit 0
else
    $ECHO "   - \e[32mThe file with the port $port is avaible.\e[0m"
fi

# Info the names and rute of files
$ECHO "* The following files will be created:
   - $fileName1
   - $fileName2
   - $fileName3"

echo -n "* Do you want to continue? (y/n): "
read response
if ! [ "$response" = "y" ]; then
  $ECHO "* \e[31mCANCELLED\e[0m"
  exit 0
fi

# Creating Files
$ECHO "* Creating files:"
#FILE .tpl
$ECHO "server {
        listen      %ip%:%proxy_port%;
        server_name %domain_idn% %alias_idn%;
        error_log   /var/log/%web_system%/domains/%domain%.error.log error;

        include %home%/%user%/conf/web/%domain%/nginx.forcessl.conf*;

        location ~ /\.(?!well-known\/|file) {
                deny all;
                return 404;
        }

        location / {
                proxy_pass http://127.0.0.1:$port;

                location ~* ^.+\.(%proxy_extensions%)$ {
                        try_files  \$uri @fallback;

                        root       %docroot%;
                        access_log /var/log/%web_system%/domains/%domain%.log combined;
                        access_log /var/log/%web_system%/domains/%domain%.bytes bytes;

                        expires    max;
                }
        }

        location @fallback {
                proxy_pass http://127.0.0.1:$port;
        }

        location /error/ {
                alias %home%/%user%/web/%domain%/document_errors/;
        }

        location ~ /\.ht    {return 404;}
        location ~ /\.svn/  {return 404;}
        location ~ /\.git/  {return 404;}
        location ~ /\.hg/   {return 404;}
        location ~ /\.bzr/  {return 404;}
        location ~ /\.(?!well-known\/|file) {
                deny all;
                return 404;
        }

        include %home%/%user%/conf/web/%domain%/nginx.conf_*;
}" >> $fileName1
if [ "$?" -eq 0 ]; then
  $ECHO "   - $fileName1 \e[32m[OK]\e[0m"
else
  $ECHO "   - $fileName1 \e[31m[ERROR]\e[0m"
fi


$ECHO "server {
        listen      %ip%:%proxy_ssl_port% ssl;
        server_name %domain_idn% %alias_idn%;
        error_log   /var/log/%web_system%/domains/%domain%.error.log error;

        ssl_certificate     %ssl_pem%;
        ssl_certificate_key %ssl_key%;
        ssl_stapling        on;
        ssl_stapling_verify on;

        # TLS 1.3 0-RTT anti-replay
        if (\$anti_replay = 307) { return 307 https://\$host\$request_uri; }
        if (\$anti_replay = 425) { return 425; }

        include %home%/%user%/conf/web/%domain%/nginx.hsts.conf*;

        location ~ /\.(?!well-known\/|file) {
                deny all;
                return 404;
        }

        location / {
                proxy_pass http://127.0.0.1:$port;

                location ~* ^.+\.(%proxy_extensions%)$ {
                        try_files  \$uri @fallback;

                        root       %sdocroot%;
                        access_log /var/log/%web_system%/domains/%domain%.log combined;
                        access_log /var/log/%web_system%/domains/%domain%.bytes bytes;

                        expires    max;
                }
        }

        location @fallback {
                proxy_pass http://127.0.0.1:$port;
        }

        location /error/ {
                alias %home%/%user%/web/%domain%/document_errors/;
        }

        location ~ /\.ht    {return 404;}
        location ~ /\.svn/  {return 404;}
        location ~ /\.git/  {return 404;}
        location ~ /\.hg/   {return 404;}
        location ~ /\.bzr/  {return 404;}
        location ~ /\.(?!well-known\/|file) {
                deny all;
                return 404;
        }

        proxy_hide_header Upgrade;

        include %home%/%user%/conf/web/%domain%/nginx.ssl.conf_*;
}" >> $fileName2
if [ "$?" -eq 0 ]; then
  $ECHO "   - $fileName2 \e[32m[OK]\e[0m"
else
  $ECHO "   - $fileName2 \e[31m[ERROR]\e[0m"
fi


$ECHO "#!/bin/bash

user=\$1
domain=\$2
ip=\$3
home=\$4
docroot=\$5

nodeDir=\"\$home/\$user/web/\$domain/$nodeFolder\"

mkdir \$nodeDir
chown -R \$user:\$user \$nodeDir" >> $fileName3
if [ "$?" -eq 0 ]; then
  $ECHO "   - $fileName3 \e[32m[OK]\e[0m"
else
  $ECHO "   - $fileName3 \e[31m[ERROR]\e[0m"
fi

$ECHO "* Changing the permissions of the files (755 and 644):"
chmod 644 $fileName1
if [ "$?" -eq 0 ]; then
  $ECHO "   - $fileName1 (644) \e[32m[OK]\e[0m"
else
  $ECHO "   - $fileName1 (644) \e[31m[ERROR]\e[0m"
fi

chmod 644 $fileName2
if [ "$?" -eq 0 ]; then
  $ECHO "   - $fileName2 (644) \e[32m[OK]\e[0m"
else
  $ECHO "   - $fileName2 (644) \e[31m[ERROR]\e[0m"
fi

chmod 755 $fileName3
if [ "$?" -eq 0 ]; then
  $ECHO "   - $fileName3 (755) \e[32m[OK]\e[0m"
else
  $ECHO "   - $fileName3 (755) \e[31m[ERROR]\e[0m"
fi

$ECHO " \e[1;34m = SCRIPT FINISHED = \e[0m"