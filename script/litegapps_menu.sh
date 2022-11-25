#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Litegapps controller
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#
litegapps_menu_version=1.0
litegapps_menu_code=10
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
print_title(){
	clear
	printmid "${YELLOW}$1${GREEN}"
	print " "
	}

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
end_menu(){
	print " "
	print "${YELLOW}1. Back"
	print " "
	echo -n "${VIOLET} Select Menu : ${CYAN}"
	read lol
	}
SELECT(){
	print
	echo -n "${YELLOW}Choose one of the numbers : ${CYAN}"
	read PILIH
	}
print_true(){
	print "${GREEN}${1} = ${GREEN}${2}${GREEN}"
	}
print_false(){
	print "${GREEN}${1} = ${WHITE}${2}${GREEN}"
	}
#
export base=/data/adb/litegapps_controller
export BASE=$base
export BIN=$BASE/xbin
export PATH=/sbin:/sbin/su:/su/bin:/su/xbin:/system/bin:/system/xbin:/data/adb/litegapps_controller/xbin:/data/data/com.termux/files/usr/bin
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
# Mount
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#mount
clear

SYSTEM=/system
SYSDIR=$SYSTEM
PRODUCT=/product
SYSTEM_EXT=/system_ext

umount /
mount -o rw,remount /
for Y79 in $PRODUCT $SYSTEM_EXT; do
	if [ -d $Y79 ]; then
		mount -o rw,remount $Y79
		if [ $? -eq 0 ]; then
			print "- mounting <$Y79>"
		else
			print "! mounting <$Y79> Failed"; sleep 3s
		fi
	fi
done

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#dec
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
findarch=$(getp5 ro.product.cpu.abi $SYSDIR/build.prop | cut -d '-' -f -1)
SDK=$(getp5 ro.build.version.sdk $SYSDIR/build.prop)
case $findarch in
arm64) ARCH=arm64 ;;
armeabi) ARCH=arm ;;
x86) ARCH=x86 ;;
x86_64) ARCH=x86_64 ;;
*) abort " <$findarch> Your Architecture Not Support" ;;
esac

chmod -R 755 $BIN
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

MAGISK_MOD=/data/adb/modules/litegapps
if [ -f $MAGISK_MOD/module.prop ] && [ -f $MAGISK_MOD/magisk_mode_force ]; then
MODE_INSTALL=MAGISK
MODE_DESK="Magisk Module (force)"
SYSTEM_INSTALL=/data/adb/modules/litegapps/system
elif [ -f $MAGISK_MOD/module.prop ] && [ ! -f $MAGISK_MOD/android_system_force ]; then
MODE_INSTALL=MAGISK
MODE_DESK="Magisk Module"
SYSTEM_INSTALL=/data/adb/modules/litegapps/system
elif [ -f $MAGISK_MOD/android_system_force ]; then
MODE_DESK="Android system (Force)"
MODE_INSTALL=REGULER
SYSTEM_INSTALL=$SYSTEM
else
MODE_DESK="Android system"
MODE_INSTALL=REGULER
SYSTEM_INSTALL=$SYSTEM
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

end_menu(){
	print " "
	print "${YELLOW}1. Back"
	print " "
	echo -n "${VIOLET} Select Menu : ${CYAN}"
	read lol
	}
SELECT(){
	print
	echo -n "${YELLOW}Choose one of the numbers : ${CYAN}"
	read PILIH
	}
print_true(){
	print "${GREEN}${1} = ${GREEN}${2}${GREEN}"
	}
print_false(){
	print "${GREEN}${1} = ${WHITE}${2}${GREEN}"
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
	
	if [ -f $base/tmp/package-install.sh ]; then
		chmod 755 $base/tmp/package-install.sh
		. $base/tmp/package-install.sh
	else
		print " "
		print "${R} this package package-install.sh not found ! $G"
	fi
	[ ! -d $base/modules ] && mkdir -p $base/modules
	[ -d $MOD_MODULE ] && rm -rf $MOD_MODULE
	[ ! -d $MOD_MODULE ] && mkdir -p $MOD_MODULE
	list_move_package="
	litegapps-prop 
	litegapps-list
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
if [ -f $base/modules/$name/package-uninstall.sh ]; then
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
	print "- Download Package $Y"
	#DEV_MODE
	$BIN/curl --progress-bar -L -o $BASE/download/$name.zip $url
	
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
	print_title "Addon Download List"
	print "1. Core"
	print "2. Google Apps"
	print "3. Google Go"
	print "4. Etc"
	print "5. About"
	print "6. Exit"
	print
	echo -n " Select List Menu : ${V}"
	read dmenu
	case $dmenu in
	1)
	DOWNLOAD_CORE
	;;
	2)
	DOWNLOAD_GAPPS
	;;
	3)
	DOWNLOAD_GO
	;;
	4)
	DOWNLOAD_ETC
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
	sleep 2s
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
dirpackage=/sdcard/Android/litegapps/package
test ! -d $dirpackage && cdir $dirpackage
[ "$(ls -A $dirpackage)" ] || print "${R}! Please Add Package in ${WHITE}<$dirpackage>${G}"
numzip=0
for IZIP in $(ls -1 $dirpackage); do
	if [ -f $dirpackage/$IZIP ]; then
		numzip2=$(((numzip+1)))
		numzip=$numzip2
		install_package $dirpackage/$IZIP
	else
		print "${R} This not zip file : <$dirpackage/$IZIP>${G}"
		print " "
	fi
done
print
print "${Y} $numzip ${G}Package Installed"
menu_end
}
TOOLS_GMS_PS(){
	print_title "Clear data GMS And Play Store"
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
	end_menu
	}
TOOLS_FORCE_MAGISK(){
	local MAGISK_DIR=$MAGISK_MOD
	print_title "Force Magisk Module Mode"
	if [ -f $MAGISK_DIR/module.prop ] && [ "$(ls -A $MAGISK_DIR/system)" ]; then
		print "# already in magisk module mode"
		print " Name : $(getp name $MAGISK_DIR/module.prop)"
	elif [ -f $MAGISK_DIR/module.prop ] && [ -f $MAGISK_DIR/magisk_mode_force ]; then
		print "# already in magisk module mode (force)"
		print " Name : $(getp name $MAGISK_DIR/module.prop)"
	else 
		[ ! -d $MAGISK_DIR ] && cdir $MAGISK_DIR
		[ -f $MAGISK_DIR/android_system_force ] && del $MAGISK_DIR/android_system_force
		print "- Make Magisk Module"
		echo "id=litegapps" > $MAGISK_DIR/module.prop
		echo "name=LiteGapps Force Mode" >> $MAGISK_DIR/module.prop
		echo "version=v0.1" >> $MAGISK_DIR/module.prop
		echo "versionCode=1" >> $MAGISK_DIR/module.prop
		echo "date=14-11-2020" >> $MAGISK_DIR/module.prop
		echo "author=LiteGapps_Controller" >> $MAGISK_DIR/module.prop
		echo "description=magisk module mode force" >> $MAGISK_DIR/module.prop
		[ ! -d $MAGISK_DIR/system ] && cdir $MAGISK_DIR/system
		touch $MAGISK_DIR/magisk_mode_force
		print "- Done"
		print "- Please Restart Litegapps Controller"
	fi
	end_menu
	}
TOOLS_FORCE_ANDROID_SYSTEM(){
	print_title "Force Android System Mode"
	if [ -f $MAGISK_MOD/android_system_force ]; then
		print "- Disable Force Android System"
		del $MAGISK_MOD/android_system_force
		print "- Done"
		print "- Please Restart Litegapps Controller"
	else
		print "- Enable Force Android System"
		touch $MAGISK_MOD/android_system_force
		if [ -f $MAGISK_MOD/magisk_mode_force ]; then
			print "- Disabling Magisk Mode Force"
			del $MAGISK_MOD/magisk_mode_force
		fi
		print "- Done"
		print "- Please Restart Litegapps Controller"
	fi
	end_menu
	}
TOOLS(){
	while true; do
	clear
	printmid "${C}Tools${G}"
	print
	print "1. Clear data Gms and PlayStore"
	print "2. Clear data litegapps"
	print "3. Force Magisk Module Mode"
	print "4. Force Android System Mode"
	print "5. Back"
	print
	echo -n "${C}Select Menu : ${G}"
	read INPUT_TOOLS
	case $INPUT_TOOLS in
	1) TOOLS_GMS_PS ;;
	2)
	print_title "Clear data all litegapps"
	for W12 in /data/kopi /data/litegapps /sdcard/Android/litegapps; do
		if [ -d $W12 ]; then
			print "- Cleaning $W12"
			rm -rf $W12
		fi
	done
	end_menu
	;;
	3) TOOLS_FORCE_MAGISK ;;
	4) TOOLS_FORCE_ANDROID_SYSTEM ;;
	5 | b | back | exit | e) break ;;
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
	print " Version : $litegapps_menu_version ($litegapps_menu_code)"
	print " "
	print " Litegapps Menu is an additional feature of Litegapps or Litegapps++"
	print " "
	print " Telegram channel : https://t.me/litegapps"
	print " "
	print
	print "${Y}1. Download Package${WHITE}"
	print " Litegapps package that you can download and install"
	print " "
	print "${Y}2. Tweaks${G}"
	print " Additional features that you can activate"
	print " "
	print "${Y}3. Install ZIP Packages${WHITE}"
	print " You can install even more than one zip package!  offline.  put package.zip into /sdcard/Android/litegapps/package"
	print " "
	print "${Y}4. Settings${G}"
	print "Settings "
	print " "
	print "${Y}5. Tools${G}"
	print "Tools "
	print " "
	print "${Y}6. Updater${WHITE}"
	print " litegapps menu update"
	print " "
	menu_end
	}
while true; do
clear
printmid "${C}Litegapps Menu${G}"
print
print " ${WHITE}Mode : ${Y}$MODE_DESK ${G}"
for W900 in $SYSTEM $PRODUCT $SYSTEM_EXT; do
	if [ -d $W900 ]; then
		touch $W900/wahyu6070 2>/dev/null
		if [ -f $W900/wahyu6070 ]; then
			del $W900/wahyu6070
		else
			print "$R ERROR : your <$W900> cannot be modified !!! $G"
		fi
	fi
done
print
print "1.Check package"
print "2.Fix"
print "3.Install ZIP packages"
print "4.Settings"
print "5.Tools"
print "6.About "
print "7.Exit"
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
		menu_about
		;;
		7)
		break
		;;
		*)
		error "please select 1-8 !"
		sleep 2s
		;;
		esac
done




#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
