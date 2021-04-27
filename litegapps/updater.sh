#litegapps controller
#29-12-2020 - 06-03-2021
updaterversion=1.1
updatercode=2
based=/data/litegapps
bins=$based/bin

getp(){
	grep "^$1" "$2" | head -n1 | cut -d = -f 2;
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
printmid "${C}Litegapps Menu Updater${G}"
print
print "${V}- Checking Litegapps Menu${G}"
test ! -d $based/download && mkdir -p $based/download
$bins/curl -L -o $based/download/litegapps_menu https://raw.githubusercontent.com/wahyu6070/litegapps-controller/master/litegapps/litegapps_menu.sh 2>/dev/null
if [ $(getp litegapps_menu_code $based/download/litegapps_menu) -gt $(getp litegapps_menu_code $based/litegapps_menu.sh) ]; then
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
elif [ $(getp litegapps_menu_code $based/download/litegapps_menu) -eq $(getp litegapps_menu_code $based/litegapps_menu.sh) ]; then
print "  Litegapps Menu version is up to date !"
print "  Litegapps Menu Version : $(getp litegapps_menu_version $based/litegapps_menu.sh)"
fi
#del $based/download/litegapps_menu


print "${Y}- Checking Updater${G}"
$bins/curl -L -o $based/download/updater https://raw.githubusercontent.com/wahyu6070/litegapps-controller/master/litegapps/updater.sh 2>/dev/null
if [ $(getp updatercode $based/download/updater) -gt $(getp updatercode $based/updater.sh) ]; then
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

elif [ $(getp updatercode $based/download/updater) -eq $(getp updatercode $based/updater.sh) ]; then
print "  Updater version is up to date !"
print "  Updater Version : $(getp updaterversion $based/updater.sh)"
fi
del $based/download/updater

print "- Done"
print
print "${C}1.Exit"
print
echo -n "${Y}Select Menu : ${V}"
read lullll