#!/bin/bash
domain=$1
debconf-set-selections <<< "postfix postfix/mailname string $1"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install --assume-yes postfix


echo "virtual_alias_domains = $1" >> /etc/postfix/main.cf
echo "virtual_alias_maps = hash:/etc/postfix/virtual" >>/etc/postfix/main.cf

echo "@$1 support.103440.74b4b589fd0a9406@helpscout.net" >>/etc/postfix/virtual


postmap /etc/postfix/virtual


sudo service postfix reload
 