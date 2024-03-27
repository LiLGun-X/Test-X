#!/usr/bin/env bash

fun_bar() {
		comando[0]="$1"
		comando[1]="$2"
		(
			[[ -e $HOME/fim ]] && rm $HOME/fim
			[[ ! -d /etc/SSHPlus ]] && rm -rf /bin/menu
			${comando[0]} >/dev/null 2>&1
			${comando[1]} >/dev/null 2>&1
			touch $HOME/fim
		) >/dev/null 2>&1 &
		tput civis
		echo -ne "\033[1;33mกรุณารอสักครู่ \033[1;37m- \033[1;33m["
		while true; do
			for ((i = 0; i < 18; i++)); do
				echo -ne "\033[1;31m#"
				sleep 0.1s
			done
			[[ -e $HOME/fim ]] && rm $HOME/fim && break
			echo -e "\033[1;33m]"
			sleep 1s
			tput cuu1
			tput dl1
			echo -ne "\033[1;33mกรุณารอสักครู่ \033[1;37m- \033[1;33m["
		done
		echo -e "\033[1;33m]\033[1;37m -\033[1;32m สำเร็จ !\033[1;37m"
		tput cnorm
	}
 verif_ptrs () {
porta=$1
PT=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
for pton in `echo -e "$PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
    svcs=$(echo -e "$PT" | grep -w "$pton" | awk '{print $1}' | uniq)
    [[ "$porta" = "$pton" ]] && {
    	echo -e "\n\033[1;31mPORTA \033[1;33m$porta \033[1;31mEM USO PELO \033[1;37m$svcs\033[0m"
    	sleep 3
    	fun_conexao
    }
done
}


inst_sqd() {
		if netstat -nltp | grep 'squid' 1>/dev/null 2>/dev/null; then
			echo -e "\E[41;1;37m            REMOVER SQUID PROXY              \E[0m"
			echo ""
			echo -ne "\033[1;32mREALMENTE DESEJA REMOVER O SQUID \033[1;31m? \033[1;33m[s/n]:\033[1;37m "
			read resp
			[[ "$resp" = 's' ]] && {
				echo -e "\n\033[1;32mREMOVENDO O SQUID PROXY !\033[0m"
				echo ""
				rem_sqd() {
					[[ -d "/etc/squid" ]] && {
						apt-get remove squid -y >/dev/null 2>&1
						apt-get purge squid -y >/dev/null 2>&1
						rm -rf /etc/squid >/dev/null 2>&1
					}
					[[ -d "/etc/squid3" ]] && {
						apt-get remove squid3 -y >/dev/null 2>&1
						apt-get purge squid3 -y >/dev/null 2>&1
						rm -rf /etc/squid3 >/dev/null 2>&1
						apt autoremove -y >/dev/null 2>&1
					}
				}
				fun_bar 'rem_sqd'
				echo -e "\n\033[1;32mSQUID REMOVIDO COM SUCESSO !\033[0m"
				sleep 2
				clear
				fun_conexao
			} || {
				echo -e "\n\033[1;31mRetornando...\033[0m"
				sleep 2
				clear
				fun_conexao
			}
		else
			clear
			echo -e "\033[0;34m╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮\033[0m"
			echo -e "\033[0;34m┃\E[44;1;37m            INSTALADOR SQUID             \E[0m\033[0;34m┃"
			echo -e "\033[0;34m╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯\033[0m"
			echo ""
			IP=$(wget -qO- ipv4.icanhazip.com)
			echo -ne "\033[1;32mPARA CONTINUAR CONFIRME SEU IP: \033[1;37m"
			read -e -i $IP ipdovps
			[[ -z "$ipdovps" ]] && {
				echo -e "\n\033[1;31mIP invalido\033[1;32m"
				echo ""
				read -p "Digite seu IP: " IP
			}
			echo -e "\n\033[1;33mQUAIS PORTAS DESEJA ULTILIZAR NO SQUID \033[1;31m?"
			echo -e "\n\033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mDEFINA AS PORTAS EM SEQUENCIA \033[1;33mEX: \033[1;37m80 8080"
			echo ""
			echo -ne "\033[1;32mINFORME AS PORTAS\033[1;37m: "
			read portass
			[[ -z "$portass" ]] && {
				echo -e "\n\033[1;31mPorta invalida!"
				sleep 3
				fun_conexao
			}
			for porta in $(echo -e $portass); do
				verif_ptrs $porta
			done
			[[ $(grep -wc '14' /etc/issue.net) != '0' ]] || [[ $(grep -wc '8' /etc/issue.net) != '0' ]] && {
				echo -e "\n\033[1;32mINSTALANDO SQUID PROXY\033[0m\n"
				fun_bar 'apt update -y' "apt install squid3 -y"
			} || {
				echo -e "\n\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mSQUID VERSAO 3.3.X\n\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mSQUID VERSAO 3.5.X\033[0m\n"
				read -p "$(echo -e "\033[1;32mINFORME UMA OPÇÃO \033[1;37m: ")" -e -i 1 opc
				[[ -z "$opc" ]] && {
					echo -e "\n\033[1;31mOpcao invalida!"
					sleep 2
					fun_conexao
				}
				[[ "$opc" != '1' ]] && {
					[[ "$opc" != '2' ]] && {
						echo -e "\n\033[1;31mOpcao invalida !"
						sleep 2
						fun_conexao
					}
				}
				echo -e "\n\033[1;32mINSTALANDO SQUID PROXY\033[0m\n"
				fun_bar 'apt update -y' "instsqd $opc"
			}
			if [[ -d "/etc/squid/" ]]; then
				var_sqd="/etc/squid/squid.conf"
				var_pay="/etc/squid/payload.txt"
			elif [[ -d "/etc/squid3/" ]]; then
				var_sqd="/etc/squid3/squid.conf"
				var_pay="/etc/squid3/payload.txt"
			else
				echo -e "\n\033[1;33m[\033[1;31mERRO\033[1;33m]\033[1;37m: \033[1;33mO SQUID PROXY CORROMPEU\033[0m"
				sleep 2
				fun_conexao
			fi
			cat <<-EOF >$var_pay
				.whatsapp.net/
				.facebook.net/
				.twitter.com/
				.speedtest.net/
			EOF
			cat <<-EOF >$var_sqd
				acl url1 dstdomain -i 127.0.0.1
				acl url2 dstdomain -i localhost
				acl url3 dstdomain -i $ipdovps
				acl url4 dstdomain -i /SSHPLUS?
				acl payload url_regex -i "$var_pay"
				acl all src 0.0.0.0/0

				http_access allow url1
				http_access allow url2
				http_access allow url3
				http_access allow url4
				http_access allow payload
				http_access deny all
				 
				#Portas
			EOF
			for Pts in $(echo -e $portass); do
				echo -e "http_port $Pts" >>$var_sqd
				[[ -f "/usr/sbin/ufw" ]] && ufw allow $Pts/tcp
			done
			cat <<-EOF >>$var_sqd
				#Nome squid
				visible_hostname SSHPLUS 
				via off
				forwarded_for off
				pipeline_prefetch off
			EOF
			sqd_conf() {
				[[ -d "/etc/squid/" ]] && {
					service ssh restart
					/etc/init.d/squid restart
					service squid restart
				}
				[[ -d "/etc/squid3/" ]] && {
					service ssh restart
					/etc/init.d/squid3 restart
					service squid3 restart
				}
			}
			echo -e "\n\033[1;32mCONFIGURANDO SQUID PROXY\033[0m"
			echo ""
			fun_bar 'sqd_conf'
			echo -e "\n\033[1;32mSQUID INSTALADO COM SUCESSO!\033[0m"
			sleep 2.5s
			fun_conexao
		fi
	}
	addpt_sqd() {
		echo -e "\E[44;1;37m         ADICIONAR PORTA AO SQUID         \E[0m"
		echo -e "\n\033[1;33mPORTAS EM USO: \033[1;32m$sqdp\n"
		if [[ -f "/etc/squid/squid.conf" ]]; then
			var_sqd="/etc/squid/squid.conf"
		elif [[ -f "/etc/squid3/squid.conf" ]]; then
			var_sqd="/etc/squid3/squid.conf"
		else
			echo -e "\n\033[1;31mSQUID NAO ESTA INSTALADO!\033[0m"
			echo -e "\n\033[1;31mRetornando...\033[0m"
			sleep 2
			clear
			fun_squid
		fi
		echo -ne "\033[1;32mQUAL PORTA DESEJA ADICIONAR \033[1;33m?\033[1;37m "
		read pt
		[[ -z "$pt" ]] && {
			echo -e "\n\033[1;31mPorta invalida!"
			sleep 2
			clear
			fun_conexao
		}
		verif_ptrs $pt
		echo -e "\n\033[1;32mADICIONANDO PORTA AO SQUID!"
		echo ""
		sed -i "s/#Portas/#Portas\nhttp_port $pt/g" $var_sqd
		fun_bar 'sleep 2'
		echo -e "\n\033[1;32mREINICIANDO O SQUID!"
		echo ""
		fun_bar 'service squid restart' 'service squid3 restart'
		echo -e "\n\033[1;32mPORTA ADICIONADA COM SUCESSO!"
		sleep 3
		clear
		fun_squid
	}

	rempt_sqd() {
		echo -e "\E[41;1;37m        REMOVER PORTA DO SQUID        \E[0m"
		echo -e "\n\033[1;33mPORTAS EM USO: \033[1;32m$sqdp\n"
		if [[ -f "/etc/squid/squid.conf" ]]; then
			var_sqd="/etc/squid/squid.conf"
		elif [[ -f "/etc/squid3/squid.conf" ]]; then
			var_sqd="/etc/squid3/squid.conf"
		else
			echo -e "\n\033[1;31mSQUID NAO ESTA INSTALADO!\033[0m"
			echo -e "\n\033[1;31mRetornando...\033[0m"
			sleep 2
			clear
			fun_squid
		fi
		echo -ne "\033[1;32mQUAL PORTA DESEJA REMOVER \033[1;33m?\033[1;37m "
		read pt
		[[ -z "$pt" ]] && {
			echo -e "\n\033[1;31mPorta invalida!"
			sleep 2
			clear
			fun_conexao
		}
		if grep -E "$pt" $var_sqd >/dev/null 2>&1; then
			echo -e "\n\033[1;32mREMOVENDO PORTA DO SQUID!"
			echo ""
			sed -i "/http_port $pt/d" $var_sqd
			fun_bar 'sleep 3'
			echo -e "\n\033[1;32mREINICIANDO O SQUID!"
			echo ""
			fun_bar 'service squid restart' 'service squid3 restart'
			echo -e "\n\033[1;32mPORTA REMOVIDA COM SUCESSO!"
			sleep 3.5s
			clear
			fun_squid
		else
			echo -e "\n\033[1;31mPORTA \033[1;32m$pt \033[1;31mNAO ENCONTRADA!"
			sleep 3.5s
			clear
			fun_squid
		fi
	}
	fun_squid() {
		[[ "$(netstat -nplt | grep -c 'squid')" = "0" ]] && inst_sqd
			echo -e "\033[0;34m╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮\033[0m"
			echo -e "\033[0;34m┃\E[44;1;37m          GERENCIAR SQUID PROXY          \E[0m\033[0;34m┃"
			echo -e "\033[0;34m╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯\033[0m"
		[[ "$(netstat -nplt | grep -c 'squid')" != "0" ]] && {
			sqdp=$(netstat -nplt | grep 'squid' | awk -F ":" {'print $4'} | xargs)
			echo -e "\033[0;34m╼ \033[1;32mPORTAS\033[1;37m: \033[1;37m$sqdp"
			echo -e "\033[0;34m╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮\033[0m"
			VarSqdOn="REMOVER SQUID PROXY"
		} || {
			VarSqdOn="INSTALAR SQUID PROXY"
		}
		echo -e "\033[0;34m┃\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33m$VarSqdOn                \033[0;34m┃"
		echo -e "\033[0;34m┃\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mADICIONAR PORTA                    \033[0;34m┃"
		echo -e "\033[0;34m┃\033[1;31m[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mREMOVER PORTA                      \033[0;34m┃"
		echo -e "\033[0;34m┃\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mVOLTAR                             \033[0;34m┃"
		echo -e "\033[0;34m╰┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯\033[0m"
		echo -ne "\033[0;34m ╰╼\033[1;32mOQUE DESEJA FAZER \033[1;37m?\033[1;31m?\033[1;37m: "
		read x
		clear
		case $x in
		1 | 01)
			inst_sqd
			;;
		2 | 02)
			addpt_sqd
			;;
		3 | 03)
			rempt_sqd
			;;
		0 | 00)
			echo -e "\033[1;31mRetornando...\033[0m"
			sleep 1
			fun_conexao
			;;
		*)
			echo -e "\033[1;31mOpcao Invalida...\033[0m"
			sleep 2
			fun_conexao
			;;
		esac
	}
	

inst_sqd
