GREEN='\033[0;32m'
GRAY='\033[1;33m'
NC='\033[0m'

clear
echo "    ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮ 
    ┣ 1 => เปิดใช้งานการปรับแต่งความเร็วอินเทอร์เน็ต
    ┣ 2 => ปิดใช้งานการปรับแต่งความเร็วอินเทอร์เน็ต
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯     "
read -p "    ┣ Number : " LIMITINTERNET

case $LIMITINTERNET in

	1)
clear
echo "    ╭━━━━━━━━━━━━━━━━━━━╮ 
    ┣ จะเปิดใช้งานความเร็วกี่ Mb 
    ┣━━━━━━━━━━━━━━━━━━━╯     "
read -p "    ┣ Mbps : " CHDL
PERSECOND=mbit
DNLD=$CHDL$PERSECOND

TC=/sbin/tc

IF="$(ip ro | awk '$1 == "default" { print $5 }')"
IP="$(ip -o ro get $(ip ro | awk '$1 == "default" { print $3 }') | awk '{print $5}')/32"     # Host IP

U32="$TC filter add dev $IF protocol ip parent 1: prio 1 u32"

    $TC qdisc add dev $IF root handle 1: htb default 30
    $TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD
    $TC class add dev $IF parent 1: classid 1:2 htb rate $DNLD
    $U32 match ip dst $IP flowid 1:1
    $U32 match ip src $IP flowid 1:2
    echo ""
    echo ""
    echo "    ┣  ปัจจุบันใช้งานความเร็ว $CHDL Mb "  > /root/auto/speed/status
    s 3
    exit

	;;
	
	2)

TC=/sbin/tc
IF="$(ip ro | awk '$1 == "default" { print $5 }')"

    $TC qdisc del dev $IF root
    echo "    ┣  ปัจจุบันใช้งานความเร็วเต็มสปีด "  > /root/auto/speed/status
    s 3
    exit

	;;

esac

