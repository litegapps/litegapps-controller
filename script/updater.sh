# Updater.sh
# by wahyu6070
# License GPL3+
#

based=/data/adb/litegapps_controller
bins=$based/xbin

getp(){
	grep "^$1" "$2" | head -n1 | cut -d = -f 2;
	}
test_connection_main() {
  for i in google,1.1.1.1,1.0.0.1 baidu,223.5.5.5,223.6.6.6; do # Cloudflare or Ali DNS
    local domain=$(echo $i | cut -d , -f1) ip=$(echo $i | cut -d , -f2-)
    if curl --connect-timeout 3 -I https://www.$domain.com --dns-servers $ip | grep -q 'HTTP/.* 200' || ping -q -c 1 -W 1 $i.com >/dev/null 2>&1; then
      export dns="$ip"
      return 0
    fi
  done
  return 1  
}

G='\e[01;32m'		# GREEN TEXT
R='\e[01;31m'		# RED TEXT
Y='\e[01;33m'		# YELLOW TEXT
B='\e[01;34m'		# BLUE TEXT
V='\e[01;35m'		# VIOLET TEXT
Bl='\e[01;30m'		# BLACK TEXT
C='\e[01;36m'		# CYAN TEXT
W='\e[01;37m'		# WHITE TEXT
BGBL='\e[1;30;47m'	# Background W Text Bl
N='\e[0m'			# How to use (example): echo "${G}example${N}"

clear
print "${Y}               Litegapps Menu Updater${G}"
print
test ! -d $based/download && mkdir -p $based/download
LINK=https://raw.githubusercontent.com/litegapps/litegapps-controller/main/script/litegapps_menu.sh
$bins/curl -L -o $based/download/litegapps_menu $LINK 2>/dev/null
if [ $? != 0 ]; then
	print "$R Please check your internet connection $G"
	sleep 6s
	return 1
fi

if [ "$(getp litegapps_menu_code $based/download/litegapps_menu)" -gt "$(getp litegapps_menu_code $based/litegapps_menu.sh)" ]; then
	print " "
	print "  Litegapps Menu Latest version is available !"
	print "  Version     : $(getp litegapps_menu_version $based/litegapps_menu.sh)"
	print "  New Version : $(getp litegapps_menu_version $based/download/litegapps_menu)"
	print
elif [ "$(getp litegapps_menu_code $based/download/litegapps_menu)" -eq "$(getp litegapps_menu_code $based/litegapps_menu.sh)" ]; then
	print "  Litegapps Menu is up to date !"
	print "  Version : $(getp litegapps_menu_version $based/litegapps_menu.sh)"
else
	print "${R}! Failed checking latest version"
	print
fi
del $based/download/litegapps_menu

print
print
print "${C}1.Exit"
print
echo -n "${Y}Select Menu : ${V}"
read lullll