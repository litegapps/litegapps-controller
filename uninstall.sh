BASE=/adb/litegapps_controller

rm -rf /data/litegapps
rm -rf $BASE
rm -rf $SYSTEM/bin/litegapps

if [ -f /data/data/com.termux/files/usr/bin/litegapps ]; then
	rm -rf /data/data/com.termux/files/usr/bin/litegapps
fi
printlog "- Uninstalling successfully"
