if [ $TYPEINSTALL = magisk ]; then
chmod 755 /data/adb/modules_update/$ID/system/bin/litegapps
else
chmod 755 $system/bin/litegapps
fi