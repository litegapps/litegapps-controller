# LiteGapps controller
# By wahyu6070

SDKTARGET=$API
BASE=/data/adb/litegapps_controller
BIN=$BASE/bin
print
MODULEVERSION=`getp version $MODPATH/module.prop`
MODULECODE=`getp versionCode $MODPATH/module.prop`
MODULENAME=`getp name $MODPATH/module.prop`
MODULEANDROID=`getp android $MODPATH/module.prop`
MODULEDATE=`getp date $MODPATH/module.prop`
MODULEAUTHOR=`getp author $MODPATH/module.prop`
[ -n "$system" ] || system="systemless"
[ -n "$TYPEINSTALL" ] || TYPEINSTALL="magisk module"
printlog "____________________________________"
printlog "|"
printlog "| Name            : $MODULENAME"
printlog "| Version         : $MODULEVERSION"
printlog "| Build date      : $MODULEDATE"
printlog "| By              : $MODULEAUTHOR"
case $TYPEINSTALL in
magisk)
printlog "| Mode            : systemless (Magisk Module)"
;;
*)
printlog "| Mode            : non systemless"
;;
esac
printlog "|___________________________________"
printlog "|"
printlog "| Telegram        : https://t.me/litegapps"
printlog "|___________________________________"
printlog "|              Device Info"
printlog "| Name Rom        : $(GET_PROP ro.build.display.id)"
if [ "$(GET_PROP ro.product.vendor.model)" ]; then
printlog "| Device          : $(GET_PROP ro.product.vendor.model)"
elif [ "$(GET_PROP ro.product.model)" ]; then
printlog "| Device          : $(GET_PROP ro.product.model)"
else
printlog "| Device          : null"
fi

if [ "$(GET_PROP ro.product.vendor.device)" ]; then
printlog "| Codename        : $(GET_PROP ro.product.vendor.device)"
elif [ "$(GET_PROP ro.product.device)" ]; then
printlog "| Codename        : $(GET_PROP ro.product.device)"
else
printlog "| Codename        : null"
fi
printlog "| Android Version : $(GET_PROP ro.build.version.release)"
printlog "| Architecture    : $ARCH"
printlog "| Api             : $(GET_PROP ro.build.version.sdk)"
printlog "| Density         : $(GET_PROP ro.sf.lcd_density)"
if $(getprop ro.build.ab_update); then
	printlog "| Seamless        : A/B (slot $(find_slot))"
else
	printlog "| Seamless        : A only"
fi
printlog "| BootMode        : $BOOTMODE"
sedlog "| System          : $SYSTEM"
printlog "|___________________________________"


[ -d $BASE ] && rm -rf $BASE && mkdir -p $BASE || mkdir -p $BASE
print "- Installing files"
cp -af $MODPATH/script/* $BASE/

print "- installing binary"
test ! -d $BIN && mkdir -p $BIN
cp -af $MODPATH/bin/$ARCH/* $BASE/bin/

#curl
print "- installing curl"
if [ -d /dev/block/mapper ]; then
	cp -af $MODPATH/curl/dynamic/$ARCH/* $BASE/bin/
else
	cp -af $MODPATH/curl/old/$ARCH/* $BASE/bin/
fi

chmod -R 755 $BASE
#set perm bin
chmod -R 755 $BIN

test ! -d $BASE/xbin && mkdir -p $BASE/xbin
if [ -f $BIN/busybox ]; then
	print "- Installing busybox"
	$BIN/busybox --install -s $BASE/xbin
fi

for P in $(ls -1 $BIN); do
	if [ -f $BIN/$P ]; then
		print "- Linking <$P>"
		ln -sf $BIN/$P $BASE/xbin/$P
	fi
done

#copy litegapps binary
cp -pf $MODPATH/system/bin/litegapps $MODPATH/system/bin/litegapps2

if [ -f /data/adb/magisk/magiskboot ]; then
	cp -pf /data/adb/magisk/magiskboot $MODPATH/system/bin/
	chmod 755 $MODPATH/system/bin/magiskboot
fi

if [ -f /data/adb/magisk/magiskboot ]; then
print "- Magiskboot detected"
print "- Installing magiskboot"
cp -pf /data/adb/magisk/magiskboot $MODPATH/system/bin/magiskboot
chmod 755 $MODPATH/system/bin/magiskboot
fi

if [ -d /data/data/com.termux/files/usr/bin ]; then
print "- Termux Detected"
print "- Installing Binary in termux"
cp -pf $MODPATH/system/bin/litegapps /data/data/com.termux/files/usr/bin/
chmod 755 /data/data/com.termux/files/usr/bin/litegapps
fi

print "- Installing addon.d"
[ -d $SYSTEM/addon.d/28-litegapps-controller.sh ] && rm -rf $SYSTEM/addon.d/28-litegapps-controller.sh
cp -pf $MODPATH/addon/28-litegapps-controller.sh $SYSTEM/addon.d/
chmod 755 $SYSTEM/addon.d/28-litegapps-controller.sh

LIST_TMP="
$MODPATH/curl
$MODPATH/bin
$MODPATH/script
$MODPATH/addon
$MODPATH/litegapps_controller
"
print "- Clean cache"
for F in $LIST_TMP; do
	rm -rf $F
done
print
print "*Tips"
print
print "- Open Terminal"
print
print "- su"
print "- litegapps or litegapps2"
print
print