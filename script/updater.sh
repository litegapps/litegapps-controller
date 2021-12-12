#litegapps controller
#by wahyu6070
#License GPL3+
#
updaterversion=0.8
updatercode=8
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
printmid "${Y}Litegapps Menu Updater${G}"
print
print "${Y}- Checking Litegapps Menu${G}"
test ! -d $based/download && mkdir -p $based/download
$bins/curl -L -o $based/download/litegapps_menu https://raw.githubusercontent.com/litegapps/litegapps-controller/main/litegapps_controller/litegapps_menu.sh 2>/dev/null
if [ $? != 0 ]; then
print "$R Please check your internet connection $G"
sleep 6s
return 1
fi
if [ "$(getp litegapps_menu_code $based/download/litegapps_menu)" -gt "$(getp litegapps_menu_code $based/litegapps_menu.sh)" ]; then
print " "
print "  Litegapps Menu Latest version is available ! : "
print "  Old Version : $(getp litegapps_menu_version $based/litegapps_menu.sh)"
print "  New Version : $(getp litegapps_menu_version $based/download/litegapps_menu)"
print
print "- Updating"
cp -pf $based/download/litegapps_menu $based/litegapps_menu.sh
print "- Set permissions"
chmod 755 $based/litegapps_menu.sh
print "- update successful"
elif [ "$(getp litegapps_menu_code $based/download/litegapps_menu)" -eq "$(getp litegapps_menu_code $based/litegapps_menu.sh)" ]; then
print "  Litegapps Menu is up to date !"
print "  Version : $(getp litegapps_menu_version $based/litegapps_menu.sh)"
else
print "  Mode DEV !"
print "  Version old : $(getp litegapps_menu_version $based/litegapps_menu.sh)"
print "  Version new : $(getp litegapps_menu_version $based/download/litegapps_menu)" 
fi
del $based/download/litegapps_menu

print "${Y}- Checking Updater${G}"
$bins/curl -L -o $based/download/updater https://raw.githubusercontent.com/litegapps/litegapps-controller/main/litegapps_controller/updater.sh 2>/dev/null
if [ $? != 0 ]; then
print "$R Please check your internet connection $G"
sleep 6s
exit 1
fi
if [ "$(getp updatercode $based/download/updater)" -gt "$(getp updatercode $based/updater.sh)" ]; then
print
print "  Updater Latest version is available ! : "
print "  Old Version : $(getp updaterversion $based/updater.sh)"
print "  New Version : $(getp updaterversion $based/download/updater)"
print
print "- Updating"
cp -pf $based/download/updater $based/updater.sh
print "- Set permissions"
chmod 755 $based/updater.sh
print "- Update successful"

elif [ "$(getp updatercode $based/download/updater)" -eq "$(getp updatercode $based/updater.sh)" ]; then
print "  Updater is up to date !"
print "  Version : $(getp updaterversion $based/updater.sh)"
else
print "  Mode DEV !"
print "  Version old : $(getp updaterversion $based/updater.sh)"
print "  Version new : $(getp updaterversion $based/download/updater)" 
fi

del $based/download/updater

print "- Done"
print
print "${C}1.Exit"
print
echo -n "${Y}Select Menu : ${V}"
read lullll