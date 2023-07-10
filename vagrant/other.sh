
cat <<EOF >> /etc/hosts
### V project
192.168.18.201  web01
192.168.18.202  app01
192.168.18.203  rmq01
192.168.18.204  mc01
192.168.18.205  db01
EOF

touch /root/update.sh

cat <<EOF >> /etc/crontab
### Update
#!/bin/sh
dnf check-update
dnf update -y
dnf clean expire-cache -y
dnf clean packages -y
dnf autoremove -y
EOF

cat <<EOF >> /etc/crontab
### Update
@reboot root bash /root/update.sh
EOF