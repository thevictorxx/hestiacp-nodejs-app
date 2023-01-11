#=================================================================================#
# NodeJS App Template                                                             #
# THIS FILE IS FOR THE PORT 3000, IF YOU WANT ANOTHER PORT, YOU NEED CHANGE TWO   #
# PARTS OF THIS FILE (LINE 14 AND 30).                                            #
#=================================================================================#

server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;
    
    include %home%/%user%/conf/web/%domain%/nginx.forcessl.conf*;
    error_log  /var/log/%web_system%/domains/%domain%.error.log error;
    location / {
        proxy_pass http://127.0.0.1:3000;
        
        location ~* ^.+\.(%proxy_extensions%)$ {
            root           %docroot%;
            access_log     /var/log/%web_system%/domains/%domain%.log combined;
            access_log     /var/log/%web_system%/domains/%domain%.bytes bytes;
            expires        max;
            try_files      $uri @fallback;
        }
    }

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }

    location @fallback {
        proxy_pass http://127.0.0.1:3000;
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
    
}