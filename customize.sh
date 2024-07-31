# LiteGapps controller
# By wahyu6070

SDKTARGET=$API
BASE=/data/adb/litegapps_controller
BIN=$BASE/bin
chmod 755 $MODPATH/bin/litegapps-functions
#litegapps functions
. $MODPATH/bin/litegapps-functions

# main path
INITIAL install



[ -d $BASE ] && rm -rf $BASE && mkdir -p $BASE || mkdir -p $BASE
print "- Installing files"
cp -af $MODPATH/script/* $BASE/

print "- installing binary"
test ! -d $BIN && mkdir -p $BIN
cp -af $MODPATH/bin/$ARCH/* $BASE/bin/

ADS https://lovinghosethus.com/c2pv7f14tk?key=d8f2cbfe01d5df5e72b2c36ce505a08f

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


ADS https://lovinghosethus.com/c2pv7f14tk?key=d8f2cbfe01d5df5e72b2c36ce505a08f


print
print "*Tips"
print
print "- Open Terminal"
print
print "- su"
print "- litegapps or litegapps2"
print
print