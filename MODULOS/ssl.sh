#!/bin/bash
cr(){
clear
echo
system=$(cat /etc/issue.net)
date=$(date '+%Y-%m-%d <> %H:%M:%S')
echo -e "\033[1;37m $system                          $date"
echo " 888888888888                                  8b        d8  "|lolcat
echo "      88                           ,d           Y8,    ,8P   "|lolcat
echo "      88                           88            `8b  d8'    "|lolcat
echo "      88   ,adPPYba,  ,adPPYba,  MM88MMM           Y88P      "|lolcat
echo "      88  a8P_____88  I8[    ""    88  aaaaaaaa    d88b      "|lolcat
echo "      88  8PP"""""""   `"Y8ba,     88  """"""""  ,8P  Y8,    "|lolcat
echo "      88  "8b,   ,aa  aa    ]8I    88,          d8'    `8b   "|lolcat
echo "      88   `"Ybbd8"'  `"YbbdP"'    "Y888       8P        Y8  "|lolcat
                                                    \ /"|lolcat                                         
}

                                                            
                                                            
                                                            
smile="https://smile-vpn.net/scrip/Premium"



cr
echo "╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮               "
echo "                SSL                   "
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━                  "
read -p " PORT SSL  : " -e -i 80 sslp
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━╯                   "
# Install openvpn
######
######




stunnel_sm(){
if [ ! -e /etc/stunnel ]; then
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
accept = $sslp
connect = 127.0.0.1:443

END

#membuat sertifikat
cat /etc/openvpn/client-key.pem /etc/openvpn/client-cert.pem > /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
echo "┣ ❯❯❯ service ssl restart"
service stunnel4 restart > /dev/null 2>&1
fi
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



install(){
cr
stunnel_sm
menu_sm
echo "┣ ❯❯❯ Successfully installed "
echo "╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯               "
echo 
read -p "  Enter On Menu " menu
}
install



