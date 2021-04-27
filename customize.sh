# LiteGapps controller
# By wahyu6070
[ -d /data/litegapps ] && rm -rf /data/litegapps
print "- Installing litegapps controller files"
[ -d /data/litegapps ] && rm -rf /data/litegapps
cp -af $MODPATH/litegapps /data/
chmod -R 755 /data/litegapps
print "- copying addon.d"
[ -d $system/addon.d/28-litegapps-controller.sh ] && $system/addon.d/28-litegapps-controller.sh
cp -pf $MODPATH/addon/28-litegapps-controller.sh $system/addon.d/
chmod 755 $system/addon.d/28-litegapps-controller.sh
print
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