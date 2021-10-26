#!/bin/bash

domain=$1
domainpath=$2
root="/var/www/$domainpath"
block="/etc/nginx/sites-available/$domain"

# Create the Document Root directory
#sudo mkdir -p $root

# Assign ownership to your regular user account
sudo chown -R $USER:$USER $root

# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF

server {
    listen 80;
    listen [::]:80;
    return 302 https://\$server_name\$request_uri;
}

server {

    # SSL configuration

    listen 443 http2;
    listen [::]:443 http2;
    ssl        on;
    ssl_certificate         /etc/certs/$domain.pem;
    ssl_certificate_key     /etc/certs/$domain.priv.pem;


    root $root;
    index index.php index.html index.htm index.nginx-debian.html;


    server_name $domain www.$domain;
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
