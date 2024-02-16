#permissions

if [ $TYPEINSTALL = magisk ] || [ $TYPEINSTALL = ksu ]; then
	chmod 755 $MAGISKUP/system/bin/litegapps
	chmod 755 $MAGISKUP/system/bin/litegapps2
else
	chmod 755 $SYSTEM/bin/litegapps
	chmod 755 $SYSTEM/bin/litegapps2
fi
