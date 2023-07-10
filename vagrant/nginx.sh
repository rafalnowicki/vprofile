# adding repository and installing nginx		
apt update
apt install nginx -y
cat <<EOT > vproapp
upstream vproapp {

 server app01:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://vproapp;

}

}

EOT

mv vproapp /etc/nginx/sites-available/vproapp
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

cat <<EOF >> /etc/hosts
### V project
192.168.18.201  web01
192.168.18.202  app01
192.168.18.203  rmq01
192.168.18.204  mc01
192.168.18.205  db01
EOF

#starting nginx service and firewall

systemctl enable nginx
systemctl restart nginx

touch /root/update.sh

cat <<EOF >> /root/update.sh
### Update
#!/bin/sh
DEBIAN_FRONTEND=noninteractive apt-get -y update &&
DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y -u  -o Dpkg::Options::="--force-confdef" --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-change-held-packages --allow-unauthenticated
apt-get -f install &&
apt-get -y clean &&
apt-get -y autoclean &&
apt-get -y autoremove --purge &&
exit
EOF

cat <<EOF >> /etc/crontab
### Update
@reboot root sh /root/update.sh
EOF