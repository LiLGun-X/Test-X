#!/bin/bash
cr(){
clear
echo
system=$(cat /etc/issue.net)
date=$(date '+%Y-%m-%d <> %H:%M:%S')
echo -e "\033[1;37m $system                          $date"
echo "      .########.########..######..########.........##.....##"|lolcat
echo "      ....##....##.......##....##....##.............##...##."|lolcat
echo "      ....##....##.......##..........##..............##.##.."|lolcat
echo "      ....##....######....######.....##....#######....###..."|lolcat
echo "      ....##....##.............##....##..............##.##.."|lolcat
echo "      ....##....##.......##....##....##.............##...##."|lolcat
echo "      ....##....########..######.....##............##.....##"|lolcat
                                      
}

                                                            




system=$(cat /etc/issue.net)
date=$(date '+%Y-%m-%d <> %H:%M:%S')
echo -e "\033[1;37m $system                          $date"
echo -e "\E[44;1;37m           ติดตั้ง V2M             \E[0m"
echo " "
sleep 1.5s

menu_sm(){
echo "┣ ❯❯❯ Install Menu " 
cd
wget -q -O menu "https://raw.githubusercontent.com/LiLGun-X/Test-X/main/C2/2"
chmod +x menu
./menu
rm -f menu
#mv /usr/bin/menu /usr/bin/msm

}



install(){
cr
sleep 2s
menu_sm
echo "┣ ❯❯❯ Successfully installed "
echo "╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯               "
echo 
read -p "  Enter On Menu " menu
}
install


