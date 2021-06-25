# LiteGapps controller
# By wahyu6070

SYSDIR=$system
VENDIR=/vendor
SDKTARGET=$API
print
MODULEVERSION=`getp version $MODPATH/module.prop`
MODULECODE=`getp versionCode $MODPATH/module.prop`
MODULENAME=`getp name $MODPATH/module.prop`
MODULEANDROID=`getp android $MODPATH/module.prop`
MODULEDATE=`getp date $MODPATH/module.prop`
MODULEAUTHOR=`getp author $MODPATH/module.prop`
ANDROIDVERSION=$(getp ro.build.version.release $SYSDIR/build.prop)
ANDROIDMODEL=$(getp ro.product.vendor.model $VENDIR/build.prop)
ANDROIDDEVICE=$(getp ro.product.vendor.device $VENDIR/build.prop)
ANDROIDROM=$(getp ro.build.display.id $SYSDIR/build.prop)
API=`getp ro.build.version.sdk $SYSDIR/build.prop`
device_abpartition=$(getprop ro.build.ab_update)
[ -n "$device_abpartition" ] || device_abpartition="A only"
printlog "____________________________________"
printlog "|"
printlog "| Name            : $MODULENAME"
printlog "| Version         : $MODULEVERSION"
printlog "| Build date      : $MODULEDATE"
printlog "| By              : $MODULEAUTHOR"
printlog "|___________________________________"
printlog "|"
printlog "| Telegram        : https://t.me/litegapps"
printlog "|___________________________________"
printlog "|              Device Info"
printlog "| Name Rom        : $ANDROIDROM"
printlog "| Device          : $ANDROIDMODEL ($ANDROIDDEVICE)"
printlog "| Android Version : $ANDROIDVERSION"
printlog "| Architecture    : $ARCH"
printlog "| Sdk             : $SDKTARGET"
printlog "| Seamless        : $device_abpartition"
printlog "|___________________________________"
printlog " "
if [ -f /data/adb/magisk/magiskboot ]; then
	cp -pf /data/adb/magisk/magiskboot $MODPATH/system/bin/
fi
BASED6=/data/media/0/Android/litegapps/litegapps_controller
[ -d $BASED6 ] && rm -rf $BASED6
print "- Installing litegapps controller files"
cp -af $MODPATH/litegapps_controller /data/media/0/Android/litegapps/
chmod -R 755 $BASED6
if [ -d /data/data/com.termux/files/usr/bin ]; then
printlog "- Termux Detected"
printlog "- Installing Binary in termux"
cp -pf $MODPATH/system/bin/litegapps /data/data/com.termux/files/usr/bin/
chmod 755 /data/data/com.termux/files/usr/bin/litegapps
fi
print "- Installing addon.d"
[ -d $system/addon.d/28-litegapps-controller.sh ] && $system/addon.d/28-litegapps-controller.sh
cp -pf $MODPATH/addon/28-litegapps-controller.sh $system/addon.d/
chmod 755 $system/addon.d/28-litegapps-controller.sh
print
print "*Tips"
print
print "- Open Terminal"
print
print "- su"
print "- litegapps"
print
print " report bug https://t.me/litegapps"
print