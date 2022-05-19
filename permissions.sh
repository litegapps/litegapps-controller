#permissions

if [ $TYPEINSTALL = magisk ]; then
	chmod 755 $MAGISKUP/system/bin/litegapps
	chmod 755 $MAGISKUP/system/bin/litegapps2
else
	chmod 755 $SYSTEM/bin/litegapps
	chmod 755 $SYSTEM/bin/litegapps
fi
