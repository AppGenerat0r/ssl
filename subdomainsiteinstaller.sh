#!/bin/bash

domain=$1
domainpath=$2
basedomain=$3
certpath="/etc/certs/$basedomain.pem"
certpath_priv="/etc/certs/$basedomain.priv.pem"
echo $certpath
root="/var/www/$domainpath"
block="/etc/nginx/sites-available/$domain"

# Create the Document Root directory
#sudo mkdir -p $root

# Assign ownership to your regular user account
sudo chown -R $USER:$USER $root
rm $block
# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $domainpath;
    return 302 https://\$server_name\$request_uri;
}

server {
    server_name $domain;
    # SSL configuration
    access_log /var/log/nginx/$domainpath-access.log;
    error_log  /var/log/nginx/$domainpath-error.log;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl        on;
    ssl_certificate         $certpath;
    ssl_certificate_key     $certpath_priv;



    root $root;
    index index.php index.html index.htm index.nginx-debian.html;


    server_name $domain;
   error_page 404 =200 /magic.php;
        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files \$uri \$uri/ =404;
        }

location ~ /includes/config {
   deny all;
   return 404;
}

location ~ /includes {
   deny all;
   return 404;
}
location ~ /pixelcode {
   deny all;
   return 404;
}

location ~ /locale {
   deny all;
   return 404;
}

location ~ /products {
   deny all;
   return 404;
}

 location ~ /vendor {
   deny all;
   return 404;
}

  location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }

}
EOF


# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload
