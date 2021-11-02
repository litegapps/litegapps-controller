rm -rf /data/litegapps
rm -rf /adb/litegapps_controller
rm -rf $system/bin/litegapps

if [ -f /data/data/com.termux/files/usr/bin/litegapps ]; then
	rm -rf /data/data/com.termux/files/usr/bin/litegapps
fi
printlog "- Uninstalling successfully"
