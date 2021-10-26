#!/bin/bash
domain=$1
giturl=$2

### Check if a directory does not exist ###
if [ ! -d "/var/www/$domain" ] 
then
    eval `ssh-agent -s`
    $(ssh-add /home/auth; git clone "$giturl" "/var/www/$domain")
    eval "$(ssh-agent -k)"
    
fi
