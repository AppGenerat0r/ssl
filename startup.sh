boxtoken=$1
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Starting%20Build&built=false"
echo 'BEGIN RUNCMD'
printf '=======\\n\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Updating%20Server%20This%20Can%20Take%20Time&built=false"
apt update -yq
apt upgrade -yq
printf '\\n\\n=======\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Installing%20Nginx&built=false"
echo 'INSTALLING NGINX'
printf '=======\\n\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Installing%20Php&built=false"
LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y php7.3-fpm php7.3-common php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-mysql php7.3-cli php7.3-zip php7.3-curl php7.3-bcmath php-imagick
cp /etc/php/7.3/fpm/php.ini /etc/php/7.3/fpm/_php.ini.original
sed -i -e 's/fix_pathinfo=.*$/cgi.fix_pathinfo=1/' /etc/php/7.3/fpm/php.ini
printf '\\n\\n=======\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Settingup%20Firewall&built=false"
echo 'CONFIGURING UFW'
printf '=======\\n\\n'
ufw disable
cp /etc/ufw/before.rules /etc/ufw/before.original
cp /etc/ufw/before6.rules /etc/ufw/before6.original
ufw allow ssh
ufw allow http
ufw allow https
ufw allow 'Nginx HTTP'
ufw allow 'Nginx HTTPS'
ufw logging on
ufw enable
ufw status verbose
printf '\\n\\n=======\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Restarting%20Nginx%20and%20Php&built=false"
echo 'Restarting PHP AND NGINX'
printf '=======\\n\\n'
service php7.3-fpm restart
service nginx restart
printf '\\n\\n=======\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Installing%20Custom%20Scripts&built=false"
echo 'INSTALLING UPDATES'
printf '=======\\n\\n'
curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Running%20Upgrades&built=false"
apt update -yq
apt upgrade -yq
apt autoremove -yq
mkdir /etc/certs
echo 'END RUNCMD' > /home/cmd
(crontab -l 2>/dev/null; echo "* * * * * /home/scripts/gitupdate.sh") | crontab -

curl "https://sleepy.host/DigitalOceanBox/CallBack?callBackKey=$boxtoken&message=Finished&built=true"