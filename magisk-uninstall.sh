# Magisk module uninstaller

BASE=/adb/litegapps_controller

rm -rf /data/litegapps
rm -rf $BASE

if [ -f /data/adb/litegapps_controller ]; then
	rm -rf /data/adb/litegapps_controller
fi
