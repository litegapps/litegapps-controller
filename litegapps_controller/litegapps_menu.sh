#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Litegapps controller
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#
litegapps_menu_version=0.7
litegapps_menu_code=7
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
getp1(){ echo $1 | head -n1 | cut -d : -f 2; }
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
check_package(){
	pm list package | grep -q "$1"
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

base=/data/adb/litegapps_controller
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
MODE_DESK="Android system"
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
	
	name_package_module=`getp package.module $base/tmp/litegapps-prop`
	MOD_MODULE=$BASE/modules/$name_package_module
	
	if [ -f $base/tmp/litegapps-install.sh ]; then
		chmod 755 $base/tmp/litegapps-install.sh
		. $base/tmp/litegapps-install.sh
	else
		print "${R} this package litegapps-install.sh not found ! $G"
	fi
	[ ! -d $base/modules ] && mkdir -p $base/modules
	[ -d $MOD_MODULE ] && rm -rf $MOD_MODULE
	[ ! -d $MOD_MODULE ] && mkdir -p $MOD_MODULE
	list_move_package="
	litegapps-prop 
	litegapps-list
	litegapps-uninstall.sh
	litegapps-restore.sh
	package-uninstall.sh
	package-restore.sh
	module.prop
	list-debloat
	backup
	"
	for move_package in $list_move_package; do
		if [ -f $base/tmp/$move_package ]; then
			cp -pf $base/tmp/$move_package $MOD_MODULE/
		elif [ -d $base/tmp/$move_package ]; then
			cp -af $base/tmp/$move_package $MOD_MODULE/
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
	print "3.Cancel"
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
	3)
	return 0
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
		rm -rf $BASE/download
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
	if [ -f $BASE/modules/$name/litegapps-uninstall.sh ]; then
		chmod 755 $BASE/modules/$name/litegapps-uninstall.sh
		. $BASE/modules/$name/litegapps-uninstall.sh
	fi
	if [ -f $BASE/modules/$name/package-uninstall.sh ]; then
		chmod 755 $BASE/modules/$name/package-uninstall.sh
		. $BASE/modules/$name/package-uninstall.sh
	fi
	[ -d $BASE/modules/$name ] && rm -rf $base/modules/$name
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
	print "1.Android Web View"
	print "2.Chrome"
	print "3.Etc,framework"
	print "4.Gmail"
	print "5.Gms Core"
	print "6.Google Calendar Sync Adapter"
	print "7.Google Contacts Sync Adapter"
	print "8.Google Search"
	print "9.Google Services Framework"
	print "10.Google TTS"
	print "11.Location History"
	print "12.Maps"
	print "13.Photos"
	print "14.Play Store"
	print "15.Setup Wizard"
	print "16.Videos"
	print "17.Wellbeing"
	print "18.Youtube"
	print "19.Youtube Music"
	print "20.About"
	print "21.Exit"
	print
	echo -n " Select List Menu : ${V}"
	read dmenu
	case $dmenu in
	1)
	download_file AndroidWebView https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/AndroidWebView.zip/download
	;;
	2)
	download_file Chrome https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Chrome.zip/download
	;;
	3)
	download_file Etc https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Etc.zip/download
	;;
	4)
	download_file Gmail https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Gmail.zip/download
	;;
	5)
	download_file GmsCore https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GmsCore.zip/download
	;;
	6)
	download_file GoogleCalendarSyncAdapter https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GoogleCalendarSyncAdapter.zip/download
	;;
	7)
	download_file GoogleContactsSyncAdapter https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GoogleContactsSyncAdapter.zip/download
	;;
	8)
	download_file GoogleSearch https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GoogleSearch.zip/download
	;;
	9)
	download_file GoogleServicesFramework https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/GoogleServicesFramework.zip/download
	;;
	10)
	download_file GoogleTTS https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Chrome.zip/download
	;;
	11)
	download_file LocationHistory https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/LocationHistory.zip/download
	;;
	12)
	download_file Maps https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Maps.zip/download
	;;
	13)
	download_file Photos https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Photos.zip/download
	;;
	14)
	download_file PlayStore https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/PlayStore.zip/download
	;;
	15)
	download_file SetupWizard https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/SetupWizard.zip/download
	;;
	16)
	download_file Videos https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Videos.zip/download
	;;
	17)
	download_file Wellbeing https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Wellbeing.zip/download
	;;
	18)
	download_file Youtube https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/Youtube.zip/download
	;;
	19)
	download_file YoutubeMusic https://sourceforge.net/projects/litegapps/files/addon/$ARCH/$SDK/YoutubeMusic.zip/download
	;;
	20)
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
	21)
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
	print " 1. Fix Permissions system files"
	print " 2. Fix Permissions google apps"
	print " 3. Back"
	print
	echo -n "  Select Menu : "
	read perm33
	case $perm33 in
		1)
			clear
			printmid "Fix Permissions system files"
			print
			for iz in $SYSDIR/app $SYSDIR $SYSDIR/product/app $SYSDIR/product/priv-app; do
				if [ -d $iz ]; then
				 	find $iz -type f -name *.apk | while read asww; do
				 		print "${CYAN}set permission $asww"
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
			clear
			printmid "Fix Permissions Google Apps"
			print
			PACKAGE_LIST_APPS="
			com.google.android.gms
			com.android.vending
			com.google.android.play.games
			"
			for WAHYU90 in $PACKAGE_LIST_APPS; do
			PACKAGE=`getp1 $WAHYU90`
			print "- ${Y}Set permissions app : $PACKAGE $G"
			pm grant $PACKAGE_LIST_APPS android.permission.READ_CALENDAR 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.READ_CALL_LOG  2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.ACCESS_FINE_LOCATION 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.READ_EXTERNAL_STORAGE 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.ACCESS_COARSE_LOCATION 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.READ_PHONE_STATE 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.SEND_SMS 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.CALL_PHONE 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.WRITE_CONTACTS 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.CAMERA 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.WRITE_CALL_LOG 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.PROCESS_OUTGOING_CALLS 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.GET_ACCOUNTS 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.WRITE_EXTERNAL_STORAGE 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.RECORD_AUDIO 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.ACCESS_MEDIA_LOCATION 2>/dev/null
			pm grant $PACKAGE_LIST_APPS android.permission.READ_CONTACTS 2>/dev/null
		done
		menu_end
		;;
		3)
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
test ! -d $dirpackage && cdir $dirpackage
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

TOOLS(){
	while true; do
	clear
	printmid "${C}Tools${G}"
	print
	print "1. Clear data Gms and PlayStore"
	print "2. Clear data litegapps"
	print "3. Back"
	print
	echo -n "${C}Select Menu : ${G}"
	read INPUT_TOOLS
	case $INPUT_TOOLS in
	1)
	local LIST="
	com.android.vending
	com.google.android.gms
	"
	for W34 in $LIST; do
		if check_package $W34; then
			print "${G}- Clear data $W34"
			pm clear $W34 >/dev/null
		else
			print "${R}! package <$W34> not found"
		fi
	done
	sleep 3s
	;;
	2)
	for W12 in /data/kopi /data/litegapps /sdcard/Android/litegapps; do
		if [ -d $W12 ]; then
			print "- Cleaning $W12"
			rm -rf $W12
		fi
	done
	sleep 3s
	;;
	3) break ;;
	*)
	error "Please select Menu"
	sleep 2s
	;;
	esac
	done
	}
menu_settings(){
test ! -d $BASE/config && mkdir -p $BASE/config
CONFIGDIR=$BASE/config
while true; do
	clear
	printmid "${C}Settings${G}"
	if [ -f $CONFIGDIR/backup_restore ]; then
		print "${G}1.Backup And Restore = ON${G}"
	else
		print "${G}1.Backup And Restore = ${WHITE}OFF${G}"
	fi
	if [ -f /data/media/0/Android/litegapps/mode_developer ]; then
		print "${G}2.[Installer] Mode Developer = ON${G}"
	else
		print "${G}2.[Installer] Mode Developer = ${WHITE}OFF${G}"
	fi
	if [ ! -f /data/media/0/Android/litegapps/disable_post_fs ]; then
		print "${G}3.[Installer] Litegapps post fs = ON${G}"
	else
		print "${G}3.[Installer] Litegapps post fs = ${WHITE}OFF${G}"
	fi
	print "4.Exit"
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
		if [ ! -f /data/media/0/Android/litegapps/mode_developer ]; then
			echo "true" > /data/media/0/Android/litegapps/mode_developer
		elif [ -f /data/media/0/Android/litegapps/mode_developer ]; then
			rm -rf /data/media/0/Android/litegapps/mode_developer
		fi
	;;
	3)
		if [ ! -f /data/media/0/Android/litegapps/disable_post_fs ]; then
			echo "true" > /data/media/0/Android/litegapps/disable_post_fs
		elif [ -f /data/media/0/Android/litegapps/disable_post_fs ]; then
			rm -rf /data/media/0/Android/litegapps/disable_post_fs
		fi
	;;
	4)
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
	printmid "${Y}Tools${G}"
	print "Tools "
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
touch /system/wahyu6070 2>/dev/null
if [ -f /system/wahyu6070 ]; then
rm -rf /system/wahyu6070
else
print "$R ERROR : your system cannot be modified !!! $G"
fi
print
print "1.Download package"
print "2.Fix"
print "3.Install ZIP packages"
print "4.Settings"
print "5.Tools"
print "6.Updater"
print "7.About "
print "8.Exit"
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
		TOOLS
		;;
		6)
		chmod 755 $BASE/updater.sh
		. /$BASE/updater.sh
		;;
		7)
		menu_about
		;;
		8)
		break
		;;
		*)
		error "please select 1-9 !"
		sleep 2s
		;;
		esac
done




#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
