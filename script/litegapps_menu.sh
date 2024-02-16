#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Litegapps controller
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#

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

menu_tweaks(){
	while true; do
	clear
	printmid "${C}Litegapps Tweaks${G}"
	print
	print " 1. Fix Permissions system files"
	print " 2. Fix Permissions google apps"
	print " 3. Fix late notification" 
	print " 4. Back"
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
			clear
			printmid "Fix Permissions Google Apps"
			print
			local NUM=$NUM
			for GF in $(find /data/data -type f -name *gms*); do
			local NUM=$(((NUM+1)))
			print "${NUM}. Removing ${WHITE}${GF}${G}"
			done
			menu_end
		;;
		4)
		break
			;;
		*)
			error "please select menu"
			sleep 2s
			;;
	esac
	
   done
}


INSTALL_FINGEPRINT(){
	local FINGERPRINT_D=$BASE/fingerprint
	local NAME=$1
	local NAME_F=$FINGERPRINT_D/$NAME
	if [ -f /data/adb/magisk/busybox ]; then
		local DIRM=/data/adb/modules/litegapps_prop
		if [ -f $NAME_F ]; then
		del $DIRM
		cdir $DIRM
		local BRAND=`getp brand $NAME_F`
		local MANUFACTUR=`getp manufacturer $NAME_F`
		local MARKETNAME=`getp marketname $NAME_F`
		local MODEL=`getp model $NAME_F`
		local CODENAME=`getp codename $NAME_F`
		local FINGERPRINT=`getp fingerprint $NAME_F`
		print
		print
		print
		print "  ${Y}Change device profile${G}"
		print 
		print " Brand = ${WHITE}$BRAND${G}"
		print " Manufacture = ${WHITE}$MANUFACTUR${G}"
		print " Marketname = ${WHITE}$MARKETNAME${G}"
		print " Model = ${WHITE}$MODEL${G}"
		print " Codename = ${WHITE}$CODENAME${G}"
		print " Fingerprint = ${WHITE}$FINGERPRINT${G}"
		print
		print "- Make module"
		local MPROPS=$DIRM/module.prop
		echo "id=litegapps_prop" >> $MPROPS
		echo "name=LiteGapps Prop $MODEL" >> $MPROPS
		echo "version=$litegapps_menu_version" >> $MPROPS
		echo "versionCode=$litegapps_menu_code" >> $MPROPS
		echo "author=litegapps_contoller" >> $MPROPS
		echo "description=Litegapps Controller props" >> $MPROPS
		print "- Dump props"
		local PROPS=$DIRM/system.prop
		echo "ro.product.brand=$BRAND" >> $PROPS
		echo "ro.product.manufacturer=$MANUFACTUR" >> $PROPS
		echo "ro.product.marketname=$MARKETNAME" >> $PROPS
		echo "ro.product.model=$MODEL" >> $PROPS
		echo "ro.build.fingerprint=$FINGERPRINT" >> $PROPS
		#echo "ro.build.product=$CODENAME" >> $PROPS
		#vendor partition prop Android 8.0+
		if [ $API -gt 26 ]; then
		#vendor
		echo "ro.product.vendor.brand=$BRAND" >> $PROPS
		echo "ro.product.vendor.manufacturer=$MANUFACTUR" >> $PROPS
		echo "ro.product.vendor.marketname=$MARKETNAME" >> $PROPS
		echo "ro.product.vendor.model=$MODEL" >> $PROPS
		echo "ro.vendor.build.fingerprint=$FINGERPRINT" >> $PROPS
		fi
		#system and product partition prop Android 10+
		if [ $API -gt 28 ]; then
		#product
		echo "ro.product.product.brand=$BRAND" >> $PROPS
		echo "ro.product.product.manufacturer=$MANUFACTUR" >> $PROPS
		echo "ro.product.product.marketname=$MARKETNAME" >> $PROPS
		echo "ro.product.product.model=$MODEL" >> $PROPS
		echo "ro.product.build.fingerprint=$FINGERPRINT" >> $PROPS
		#system
		echo "ro.product.system.brand=$BRAND" >> $PROPS
		echo "ro.product.system.manufacturer=$MANUFACTUR" >> $PROPS
		echo "ro.product.system.marketname=$MARKETNAME" >> $PROPS
		echo "ro.product.system.model=$MODEL" >> $PROPS
		echo "ro.system.build.fingerprint=$FINGERPRINT" >> $PROPS
		fi

		#system_ext and odm partition prop Android 11+
		if [ $API -gt 29 ]; then
		#system_ext
		echo "ro.product.system_ext.brand=$BRAND" >> $PROPS
		echo "ro.product.system_ext.manufacturer=$MANUFACTUR" >> $PROPS
		echo "ro.product.system_ext.marketname=$MARKETNAME" >> $PROPS
		echo "ro.product.system_ext.model=$MODEL" >> $PROPS
		echo "ro.system_ext.build.fingerprint=$FINGERPRINT" >> $PROPS
		#odm
		echo "ro.product.odm.brand=$BRAND" >> $PROPS
		echo "ro.product.odm.manufacturer=$MANUFACTUR" >> $PROPS
		echo "ro.product.odm.marketname=$MARKETNAME" >> $PROPS
		echo "ro.product.odm.model=$MODEL" >> $PROPS
		echo "ro.odm.build.fingerprint=$FINGERPRINT" >> $PROPS
		fi
		else
			error "! Device fingerprint <$FINGERPRINT_D/$NAME> not found"
		fi
	else
		error "Please install magisk full version"
	fi

	print 
	print "${Y}+ Note${G}"
	print "To restore original device prop, you can delete it from magisk or delete directory ${WHITE}<${DIRM}>${G}"
	
	menu_end
	}
MENU_DEVICE_FINGERPRINT(){
	while true; do
	print_title "Change Device Fingerprint"
	print "$V Xiaomi${G}"
	print "1.MI 11 Ultra"
	print "2.POCO F4 (MUNCH)"
	print "3.Exit"
	print
	echo -n " Select Device : ${V}"
	read TG9
	case $TG9 in
	1)
	INSTALL_FINGEPRINT mi_11_ultra
	;;
	2)
	INSTALL_FINGEPRINT poco_f4
	;;
	3)
	break
	;;
	esac
	done
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

while true; do
clear
printmid "${C}Litegapps Menu${G}"
print
print "1.Change Device Props"
print "2.Fix"
print "3.Settings"
print "4.Tools"
print "5.Exit"
print
echo -n "Select Menu : ${V}"
read menu77
	case $menu77 in
		1)
		MENU_DEVICE_FINGERPRINT
		;;
		2)
		menu_tweaks
		;;
		3)
		menu_settings
		;;
		4)
		TOOLS
		;;
		5)
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
