#permissions

if [ $TYPEINSTALL = magisk ]; then
	chmod 755 $MAGISKUP/system/bin/litegapps
else
	chmod 755 $SYSTEM/bin/litegapps
fi
