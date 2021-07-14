#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Litegapps controller
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#29-12-2020 08-06-2021
litegapps_menu_version=1.5
litegapps_menu_code=5
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#base func
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Color
G='\e[01;32m'		# GREEN TEXT
R='\e[01;31m'		# RED TEXT
Y='\e[01;33m'		# YELLOW TEXT
B='\e[01;34m'		# BLUE TEXT
V='\e[01;35m'		# VIOLET TEXT
Bl='\e[01;30m'		# BLACK TEXT
C='\e[01;36m'		# CYAN TEXT
WHITE='\e[01;37m'		# WHITE TEXT
BGBL='\e[1;30;47m'	# Background W Text Bl
N='\e[0m'			# How to use (example): echo "${G}example${N}"
####functions
getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }

getp5(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }
spinner() {
  set +x
  PID=$!
  h=0; anim='-\|/';
  while [ -d /proc/$PID ]; do
    h=$(((h+1)%4))
    sleep 0.02
    printf "\r${@} [${anim:$h:1}]"
  done
  set -x 2>>$VERLOG
}
error() {
	print
	print "${RED}ERROR :  ${WHITE}$1${GREEN}"
	print
	}
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#dec
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
test -f /system_root/system/build.prop && SYSDIR=/system_root/system || test -f /system/system/build.prop && SYSDIR=/system/system || SYSDIR=/system
findarch=$(getp5 ro.product.cpu.abi $SYSDIR/build.prop | cut -d '-' -f -1)
SDK=$(getp5 ro.build.version.sdk $SYSDIR/build.prop)
case $findarch in
arm64) ARCH=arm64 ;;
armeabi) ARCH=arm ;;
x86) ARCH=x86 ;;
x86_64) ARCH=x86_64 ;;
*) abort " <$findarch> Your Architecture Not Support" ;;
esac

base=/data/media/0/Android/litegapps/litegapps_controller
BASE=$base
BIN=$BASE/bin
#system
SYSTEM_DIR=$SYSDIR
API=`getprop ro.build.version.sdk`
SDK=$API
ABI=`getprop ro.product.cpu.abi | cut -c-3`
ABI2=`getprop ro.product.cpu.abi2 | cut -c-3`
ABILONG=`getprop ro.product.cpu.abi`

ARCH=arm
ARCH32=arm
IS64BIT=false
if [ "$ABI" = "x86" ]; then ARCH=x86; ARCH32=x86; fi;
if [ "$ABI2" = "x86" ]; then ARCH=x86; ARCH32=x86; fi;
if [ "$ABILONG" = "arm64-v8a" ]; then ARCH=arm64; ARCH32=arm; IS64BIT=true; fi;
if [ "$ABILONG" = "x86_64" ]; then ARCH=x64; ARCH32=x86; IS64BIT=true; fi;

if [ -f /data/adb/modules/litegapps/module.prop ]; then
MODE_INSTALL=MAGISK
MODE_DESK="Magisk Module"
SYSTEM_INSTALL=/data/adb/modules/litegapps/system
else
MODE_DESK="LiteGapps Module"
MODE_INSTALL=REGULER
SYSTEM_INSTALL=/system
fi


#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#main func
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
DEV_MODE(){
	chmod 755 $BIN/zip
	DEFAULT_DIR=$(pwd)
	DEV_BASE=/data/media/0/lol/package
	cd $DEV_BASE
	$BIN/zip -r1 package.zip * >/dev/null
	cp -pf $DEV_BASE/package.zip $BASE/download/$name.zip
	rm -rf $DEV_BASE/package.zip
	cd $DEFAULT_DIR
	}
menu_end(){
	print " "
	print "${C}1.Back     ${Y}2.Reboot"
	print
	print
	echo -n " ${G}Select menu : ${V}"
	read menu_end2
	case $menu_end2 in
	1) clear ;;
	2) reboot ;;
	*) clear ;;
	esac
	}

install_package(){
	local input="$1"
	rm -rf $base/tmp
	mkdir -p $base/tmp
	print "- Extracting package"
	print " "
	chmod 755 $BIN/unzip
	$BIN/unzip -o "$input" -d  $base/tmp/ >/dev/null
	if [ $? -eq 0 ]; then
		print "- Unzip ${G}[OK]${G}"
	else
		print "- Unzip ${R}[ERROR]${WHITE} <$input>"
		print " "
		print "${R}Package is corrupt !!"
		return 1
	fi
	if [ -f $base/tmp/litegapps-install.sh ]; then
		chmod 755 $base/tmp/litegapps-install.sh
		. $base/tmp/litegapps-install.sh
	else
		print "${R} this package litegapps-install.sh not found ! $G"
	fi
	
	name_package_module=`getp package.module $base/tmp/litegapps-prop`
	[ ! -d $base/modules ] && mkdir -p $base/modules
	[ -d $base/modules/$name_package_module ] && rm -rf $base/modules/$name_package_module
	[ ! -d $base/modules/$name_package_module ] && mkdir -p $base/modules/$name_package_module
	for move_package in litegapps-prop litegapps-list litegapps-uninstall.sh litegapps-restore.sh module.prop list-debloat backup; do
		if [ -f $base/tmp/$move_package ]; then
			cp -pf $base/tmp/$move_package $base/modules/$name_package_module/
		elif [ -d $base/tmp/$move_package ]; then
			cp -af $base/tmp/$move_package $base/modules/$name_package_module/
		fi
	done
	rm -rf $base/tmp
	}
	
	
	
download_file(){
url=$2
name=$1
if [ -f $base/modules/$name/litegapps-uninstall.sh ]; then
	while true; do
	clear
	printmid "${C}Select mode${G}"
	print
	print "1.Install"
	print "2.Uninstall"
	print
	echo -n "${G}Select Menu :${WHITE} "
	read menuin
	case $menuin in
	1)
	modeselect=install
	break
	;;
	2)
	modeselect=uninstall
	break
	;;
	*)
	error "please select 1 or 2"
	;;
	esac
	done
else
modeselect=install
fi

if [ "$modeselect" = "install" ]; then
	clear
	printmid "${C}Install packages${G}"
	print
	[ -d $BASE/download ] && rm -rf $BASE/download
	test ! -d $BASE/download && mkdir -p $BASE/download
	print "- Download package"
	#DEV_MODE
	$BIN/curl -L -o $BASE/download/$name.zip $url
	
	if [ $? -eq 0 ]; then
		print "${WHITE}- Downloading status : ${G}[OK]${WHITE}"
		install_package $BASE/download/$name.zip
		rm -rf $base/download
	else
    	print "${R} !!! Downloading Package Failed !!!"
    	print " "
    	print "${G}* Tips"
    	print " "
    	print " Please check your internet connection and try again${WHITE}"
    	print " "
    fi
elif [ "$modeselect" = "uninstall" ]; then
	clear
	printmid "${C}Uninstall Packages${G}"
	print
	if [ -f $base/modules/$name/litegapps-uninstall.sh ]; then
		chmod 755 $base/modules/$name/litegapps-uninstall.sh
		. $base/modules/$name/litegapps-uninstall.sh
	fi
	[ -d $base/modules/$name ] && rm -rf $base/modules/$name
	print
fi

menu_end
}


#################################################
#Menu functions
#################################################
menu_download(){
	while true; do
	clear
	printmid "${C}Packages List${G}"
	print
	print "1.Google Services Framework"
	print "2.GMS"
	print "3.Play Store"
	print "4.Setup Wizard"
	print "5.About"
	print "6.Exit"
	print
	echo -n " Select List Menu : ${V}"
	read dmenu
	case $dmenu in
	1)
	download_file GoogleServiceFramework https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GoogleServiceFramework.zip/download
	;;
	2)
	download_file GmsCore https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GmsCore.zip/download
	;;
	3)
	download_file PlayStore https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/PlayStore.zip/download
	;;
	4)
	download_file SetupWizard https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/SetupWizard.zip/download
	;;
	5)
	clear
	printmid "${C}About${G}"
	print
	print "This is a tool to download manual Litegapps packages."
	print
	printmid "${Y}Problem Solving${WHITE}"
	print "1.make sure you have a good internet connection"
	print "2.make sure you are using the latest version of litegapps controller"
	print
	print "${C}Report bug : https://t.me/litegapps${C}"
	print
	menu_end
	;;
	6)
	break
	;;
	*)
	error "Please select number in menu list" 
	;;
	esac
	done
	
	}
menu_tweaks(){
	while true; do
	clear
	printmid "${C}Litegapps Tweaks${G}"
	print
	print " 1. Fix Permissions"
	print " 2. Back"
	print
	echo -n "  Select Menu : "
	read perm33
	case $perm33 in
		1)
			clear
			printmid "Fix Permissions"
			print
			for iz in $SYSDIR/app $SYSDIR $SYSDIR/product/app $SYSDIR/product/priv-app; do
				if [ -d $iz ]; then
				 	find $iz -type f -name *.apk | while read asww; do
				 		print "${CYAN}set permissions $asww"
				 		chmod 644 $asww
				 		chcon -h u:object_r:system_file:s0 $asww
				 		print "${GREEN}set permission $(dirname $asww)"
				 		chmod 755 $(dirname $asww)
				 		chcon -h u:object_r:system_file:s0 $(dirname $asww)
				 	done
				fi
		     done
				
		     menu_end
			;;
		2)
		break
			;;
		*)
			error "please select menu"
			sleep 2s
			;;
	esac
	
   done
}

menu_zip_install(){
clear
printmid "${C}Package ZIP install${G}"
print " "
dirpackage=/data/media/0/Android/litegapps/package
numzip=0
for IZIP in $(ls -1 $dirpackage); do
	if [ -f $dirpackage/$IZIP ]; then
		numzip2=$(((numzip+1)))
		numzip=$numzip2
		install_package $dirpackage/$IZIP
	else
		print "${R} This not zip file : <$dirpackage/$IZIP>"
	fi
done
print
print "${Y} $numzip ${G}Package Installed"
menu_end
}


menu_settings(){
test ! -d /data/litegapps/config && mkdir -p /data/litegapps/config
CONFIGDIR=/data/litegapps/config
while true; do
if [ -f $CONFIGDIR/backup_restore ]; then
backup_restore="${G}1.Backup And Restore = ON${G}"
else
backup_restore="${G}1.Backup And Restore = ${WHITE}OFF${G}"
fi
clear
printmid "${C}Settings${G}"
print
print "$backup_restore"
print "2.Exit"
print
echo -n "${C}Select Menu : ${G}"
read inputsetting
case $inputsetting in
1)
if [ ! -f $CONFIGDIR/backup_restore ]; then
echo "true" > $CONFIGDIR/backup_restore
elif [ -f $CONFIGDIR/backup_restore ]; then
rm -rf $CONFIGDIR/backup_restore
fi
;;
2)
break
;;
*)
error "Please select Menu"
sleep 2s
;;
esac
done
}
menu_about(){
	clear
	printmid "${C}About Litegapps Menu${G}"
	print
	print "Litegapps Menu Version : $litegapps_menu_version ($litegapps_menu_code)"
	print "Litegapps Menu is an additional feature of Litegapps or Litegapps++"
	print " "
	print "Telegram channel : https://t.me/litegapps"
	print " "
	print
	printmid "${Y}Download Package${WHITE}"
	print " Litegapps package that you can download and install"
	print " "
	printmid "${Y}Tweaks${G}"
	print " Additional features that you can activate"
	print " "
	printmid "${Y}Install ZIP Packages${WHITE}"
	print " You can install even more than one zip package!  offline.  put package.zip into /sdcard/Android/litegapps/package"
	print " "
	printmid "${Y}Settings${G}"
	print "Settings "
	print " "
	printmid "${Y}Updater${WHITE}"
	print " litegapps menu update"
	print " "
	menu_end
	}
while true; do
clear
printmid "${C}Litegapps Menu${G}"
print
print " ${WHITE} Mode : ${Y}$MODE_DESK ${G}"
print
print "1.Download package"
print "2.Tweaks"
print "3.Install ZIP packages"
print "4.Settings"
print "5.Updater"
print "6.about "
print "7.exit"
print
echo -n "Select Menu : ${V}"
read menu77
	case $menu77 in
		1)
		menu_download
		;;
		2)
		menu_tweaks
		;;
		3)
		menu_zip_install
		;;
		4)
		menu_settings
		;;
		5)
		chmod 755 $BASE/updater.sh
		. /$BASE/updater.sh
		;;
		6)
		menu_about
		;;
		7)
		break
		;;
		*)
		error "please select 1-7 !"
		sleep 2s
		;;
		esac
done




#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
