
#!/usr/bin/env bash

versionchek(){
source /etc/os-release
}

cr(){
clear
system=$(cat /etc/issue.net)
date=$(date '+%Y-%m-%d <> %H:%M:%S')
echo -e "\033[1;37m $system                          $date"
echo ""
echo "       ░▒█░▒█░▒█░░▒█░▒█▀▀█░▒█▀▀▀░▒█▀▀▄░░░░▀▄░▄▀"|lolcat
echo "       ░▒█▀▀█░▒▀▄▄▄▀░▒█▄▄█░▒█▀▀▀░▒█▄▄▀░▀▀░░▒█░░"|lolcat
echo "       ░▒█░▒█░░░▒█░░░▒█░░░░▒█▄▄▄░▒█░▒█░░░░▄▀▒▀▄"|lolcat
echo "                                         𝙎𝘾𝙍𝙄𝙋𝙏"
    sleep 0.01
echo -e "\e[33m    ┣━━┫   Scrip Mod By Test-X7          "
    sleep 0.01
echo -e "\e[34m    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫               "
echo -e "\e[35m    ╰━━━━━━━━━━━━━┫ Setup OpenVPN $ID $VERSION_ID         \e[m"
}
update(){
echo "┣ ❯❯❯ apt-get update"
apt-get update -q > /dev/null 2>&1
}

openvpn_sm(){
echo '
clear
cr
echo " "' >> .bashrc

rm -f /var/lib/dpkg/lock
rm -f /var/cache/apt/archives/lock
rm -f /var/lib/dpkg/lock-frontend

smile="https://smile-vpn.net/scrip/Premiums"

dpkg -l openvpn > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮               "
    echo "┣ ❯❯❯ ได้ติดตั้ง openvpn ใว้แล้วก่อนหน้านี้       "
    echo "┣ ❯❯❯ ต้องการถอนติดตั้งรันใหม่หรือไม่       "
    echo "┣ ❯❯❯ ไม่รับประกันว่าจะผ่าน 100%        "
    echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━╯               "
    read -p "         ┣━ Y/n : " FF
    if [[ "$FF" = "y" || "$FF" = "Y" ]]; then
 echo "╰ ❯❯❯ กำลังถอนติดตั้ง Openvpn        "
 apt-get -y --purge remove openvpn* > /dev/null 2>&1
 rm -r -f /etc/openvpn
 mkdir -p /etc/openvpn
    clear
   echo
    cr
    else
   exit
   fi
fi

# Sanity check
if [[ $(id -g) != "0" ]] ; then
    des "┣ ❯❯❯ Script must be run as root."
fi

if [[  ! -e /dev/net/tun ]] ; then
    des "┣ ❯❯❯ TUN/TAP device is not available."
fi



# IP Address
SERVER_IP=$(hostname -I | sed -n '1p' | awk '{print $1}')
if [[ "$SERVER_IP" = "" ]]; then
SERVER_IP = 127.0.0.1
fi
echo "╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮               "
read -p "            IP Server  : " -e -i $SERVER_IP SERVER_IP
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━                  "
echo "$SERVER_IP" > /usr/bin/ipsm
read -p "            Port OpenVPN  : " -e -i 443 port
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━                  "
read -p "            Limit OpenVPN  : " -e -i 5000 limit
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━╯                   "
# Install openvpn

echo "┣ ❯❯❯ apt-get install openvpn    "
cd /
wget -q -O ovpn.tar "$smile/Install/conf/open-u18.04.tar"
tar xf ovpn.tar
rm -f ovpn.tar

sed -i "s/255.255.252.0/255.255.0.0/g" /etc/openvpn/server.conf
sed -i "s/port 443/port $port/g" /etc/openvpn/server.conf
sed -i "s/duplicate-cn/#management $SERVER_IP 2222/g" /etc/openvpn/server.conf
echo " 
max-clients $limit
" >> /etc/openvpn/server.conf


apt-get install -qy openvpn > /dev/null 2>&1

# Restart Service
echo "┣ ❯❯❯ service openvpn restart"
service openvpn restart > /dev/null 2>&1
}


nginx_sm(){
#install Nginx
if [ ! -e /etc/nginx ]; then
echo "┣ ❯❯❯ apt-get install nginx"
mkdir -p /home/vps/public_html
apt-get install -qy nginx > /dev/null 2>&1
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "$smile/Install/conf/nginx.conf"
wget -q -O /etc/nginx/conf.d/vps.conf "$smile/Install/conf/vps.conf"
sed -i "s/80/85/g" /etc/nginx/conf.d/vps.conf
wget -q -O /home/vps/public_html/index.php "$smile/check_online/on.txt"
chmod -R 777 /etc/openvpn/*.log
echo "┣ ❯❯❯ service nginx restart"
service nginx restart > /dev/null 2>&1
fi
}

php_sm(){
if [[ ! -e /etc/php ]]; then
#install php-fpm
echo "┣ ❯❯❯ apt-get install php"
apt-get install -qy php-fpm > /dev/null 2>&1
apt-get install -qy php-curl > /dev/null 2>&1
sed -i "s/listen = \/run\/php\/php$(ls \/etc\/php)-fpm.sock/listen = 127.0.0.1:9000/g" /etc/php/$(ls \/etc\/php)/fpm/pool.d/www.conf
echo "┣ ❯❯❯ service php restart"
service php$(ls /etc/php)-fpm restart > /dev/null 2>&1
fi
}

stunnel_sm(){
#if [ ! -e /etc/stunnel ]; then
#detail nama perusahaan
country=ID
state=Thailand
locality=Tebet
organization=sakariya
organizationalunit=IT
commonname=Smile-vpn.net
email=sakariyamisayalong@gmail.com


# install stunnel
echo "┣ ❯❯❯ apt-get install ssl"
apt-get install -qy stunnel4 > /dev/null 2>&1
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[openvpn]
accept = 80
connect = 127.0.0.1:443

END

#membuat sertifikat
cat /etc/openvpn/client-key.pem /etc/openvpn/client-cert.pem > /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
echo "┣ ❯❯❯ service ssl restart"
service stunnel4 restart > /dev/null 2>&1
#fi
}


vnstat_sm(){
#install vnstat
if [ ! -e /home/vps/public_html/api ]; then

echo "┣ ❯❯❯ apt-get install vnstat"
apt-get install -qy vnstat > /dev/null 2>&1
chown -R vnstat:vnstat /var/lib/vnstat

# install vnstat gui
apt-get -y --purge remove vnstat* > /dev/null 2>&1
apt-get install -qy vnstat > /dev/null 2>&1

echo "┣ ❯❯❯ service vnstat restart"
service vnstat restart > /dev/null 2>&1

if [ -e '/var/lib/vnstat/eth0' ]; then
	vnstat -u -i eth0
fi
if [ -e '/var/lib/vnstat/ens3' ]; then
#sed -i "s/eth0/ens3/g" /home/vps/public_html/api/config.php
sed -i 's/eth0/ens3/g' /etc/vnstat.conf
vnstat -u -i ens3
fi

if [ -e '/var/lib/vnstat/ens160' ]; then
#sed -i "s/eth0/ens160/g" /home/vps/public_html/api/config.php
sed -i 's/eth0/ens160/g' /etc/vnstat.conf
vnstat -u -i ens160
fi

if [ -e '/var/lib/vnstat/ens18' ]; then
#sed -i "s/eth0/ens18/g" /home/vps/public_html/api/config.php
sed -i 's/eth0/ens18/g' /etc/vnstat.conf
vnstat -u -i ens18
fi

fi
}

Iptables_sm(){
# Iptables
if [ ! -e /usr/bin/iptaables_ok ]; then
echo "┣ ❯❯❯ apt-get install iptables"
apt-get install -qy iptables > /dev/null 2>&1
apt-get install -qy iptables-persistent
#if [ -e '/var/lib/vnstat/eth0' ]; then
#iptables -t nat -I POSTROUTING -s 10.8.0.0/16 -o eth0 -j MASQUERADE
#elif [ -e '/var/lib/vnstat/ens3' ]; then
#iptables -t nat -I POSTROUTING -s 10.8.0.0/16 -o ens3 -j MASQUERADE
#else
#iptables -t nat -I POSTROUTING -s 10.8.0.0/16 -o ens18 -j MASQUERADE
#fi
iptables -I FORWARD -s 10.8.0.0/16 -j ACCEPT
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -j SNAT --to-source $SERVER_IP
#iptables-save > /etc/iptables.conf
iptables-save > /etc/iptables/rules.v4

cat > /etc/network/if-up.d/iptables <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.conf
EOF

#chmod +x /etc/network/if-up.d/iptables

# Enable net.ipv4.ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
echo iptaables > /usr/bin/iptaables_ok
fi
}

setting_time(){
# setting time
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart > /dev/null 2>&1
}

menu_sm(){
if [ ! -e /usr/bin/bwh ]; then
echo "┣ ❯❯❯ Install Menu " 
cd
wget -q -O menu "$smile/menu/menu.php"
chmod +x menu
./menu
rm -f menu
#mv /usr/bin/menu /usr/bin/msm

if [[ -e /etc/debian_version ]]; then
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
fi

if [[ "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
wget -q -O /usr/bin/bwh "$smile/menu/bwh"
chmod +x /usr/bin/bwh
elif [[ "$VERSION_ID" = 'VERSION_ID="9"' || "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then
wget -q -O /usr/bin/bwh "$smile/menu/bwhd9"
chmod +x /usr/bin/bwh
else
wget -q -O /usr/bin/bwh "$smile/menu/bwhd10"
chmod +x /usr/bin/bwh
 fi
 
sed -i 's/4468.conf/server.conf/g' /usr/bin/sm
sed -i 's/log.log/openvpn-status.log/g' /usr/bin/g
sed -i 's/log.log/openvpn-status.log/g' /usr/bin/k
fi
}

drop_caches(){
echo "echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'" > /usr/bin/drop_caches.sh
chmod 755 /usr/bin/drop_caches.sh
echo "*/30 * * * * root /usr/bin/drop_caches.sh" > /etc/cron.d/drop_caches
service cron restart
}

failban(){
echo "┣ ❯❯❯ Install Fail2ban " 
apt-get install -qy fail2ban > /dev/null 2>&1
wget -q -O /etc/fail2ban/jail.local "$smile/fail2ban/jail.txt"
echo "┣ ❯❯❯ service fail2ban restart"
systemctl restart fail2ban.service > /dev/null 2>&1
}

login_noty(){
wget -q -O /etc/ssh/sshrc "$smile/fail2ban/login_nofy.txt"
}


socks_ws(){
echo "┣ ❯❯❯ Install Socks Proxy " 
wget -q -O /etc/SSHPlus/wsproxy.py "$smile/Modulos/wsproxy.py"
for pidproxy in $(screen -ls | grep ".ws" | awk {'print $1'}); do
screen -r -S "$pidproxy" -X quit
done
[[ $(grep -wc "wsproxy.py" /etc/autostart) != '0' ]] && {
sed -i '/wsproxy.py/d' /etc/autostart
}
[[ $(grep -wc "proxy.py" /etc/autostart) != '0' ]] && {
sed -i '/proxy.py/d' /etc/autostart
}

screen -dmS ws python /etc/SSHPlus/wsproxy.py 2082
echo -e "netstat -tlpn | grep -w 2082 > /dev/null && echo 'NO' || screen -dmS ws python /etc/SSHPlus/wsproxy.py 2082" >>/etc/autostart
screen -dmS ws python /etc/SSHPlus/proxy.py 3128
echo -e "netstat -tlpn | grep -w 3128 > /dev/null && echo 'NO' || screen -dmS ws python /etc/SSHPlus/proxy.py 3128" >>/etc/autostart
echo "* * * * * root /etc/autostart" > /etc/cron.d/proxy
}

install(){
versionchek
cr
openvpn_sm
nginx_sm
php_sm
stunnel_sm
socks_ws
vnstat_sm
Iptables_sm
login_noty
failban
setting_time
menu_sm
drop_caches
update
echo "┣ ❯❯❯ Successfully installed "
echo "╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯               "
echo 
read -p "  Enter On Menu " menu
}

if [[ $1 == "openvpn" ]]; then
install
fi

