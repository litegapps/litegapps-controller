#!/sbin/sh
#
#Litegapps controller
#by wahyu6070
#LICENSE GPL+ 
#Latest Update  14-07-2021
. /tmp/backuptool.functions
log=/data/media/0/Android/litegapps/28-litegapps-controller.log
BASE=/data/adb/litegapps_controller

[ ! -d $(dirname $log) ] && mkdir -p $(dirname $log)

ps | grep zygote | grep -v grep >/dev/null && BOOTMODE=true || BOOTMODE=false
$BOOTMODE || ps -A 2>/dev/null | grep zygote | grep -v grep >/dev/null && BOOTMODE=true

if ! $BOOTMODE; then
# update-binary|updater <RECOVERY_API_VERSION> <OUTFD> <ZIPFILE>
 OUTFD=$(ps | grep -v 'grep' | grep -oE 'update(.*) 3 [0-9]+' | cut -d" " -f3)
 [ -z $OUTFD ] && OUTFD=$(ps -Af | grep -v 'grep' | grep -oE 'update(.*) 3 [0-9]+' | cut -d" " -f3)
 # update_engine_sideload --payload=file://<ZIPFILE> --offset=<OFFSET> --headers=<HEADERS> --status_fd=<OUTFD>
 [ -z $OUTFD ] && OUTFD=$(ps | grep -v 'grep' | grep -oE 'status_fd=[0-9]+' | cut -d= -f2)
 [ -z $OUTFD ] && OUTFD=$(ps -Af | grep -v 'grep' | grep -oE 'status_fd=[0-9]+' | cut -d= -f2)
 fi
 ui_print() { $BOOTMODE && log -t Magisk -- "$1" || echo -e "ui_print $1\nui_print" >> /proc/self/fd/$OUTFD; }

print(){
	ui_print "$1"
	}
sedlog(){
	echo "[Processing]  $1 [$(date '+%d/%m/%Y %H:%M:%S')]" >> $log
	}
	
	
getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }
ch_con(){
chcon -h u:object_r:system_file:s0 "$1" || setlog "Failed chcon $1"
}


if [ -f /system/system/build.prop ]; then
system=/system/system
elif [ -f /system_root/system/build.prop ]; then
system=/system_root/system
elif [ -f /system_root/build.prop ]; then
system=/system_root
else
system=/system
fi
vendor=/vendor

#enable/disable backup and restore
if [ ! -f $BASE/config/backup_restore ]; then
sedlog "config backup_restore is disable"
exit 0
fi


case "$1" in
  backup)
  print "Litegapps Controller Backup"
  for b in $(ls -1 $BASE/modules); do
  	if [ -f $BASE/modules/$b/litegapps-list ]; then
   	 for i in $(cat $BASE/modules/$b/litegapps-list); do
    			if [ -f $S/$i ] && [ ! -L $S/$i ] ; then
    				sedlog "- Backuping •> $S/$i"
    				backup_file $S/$i
    			fi
    	done
  	fi
  done
  ;;
  restore)
  print "Litegapps Controller Restore"
  for b in $(ls -1 $BASE/modules); do
  	if [ -f $BASE/modules/$b/litegapps-list ]; then
  	[ -f $BASE/modules/$b/litegapps-prop ] && printlog "• Restoring •> $(getp package.name $base/modules/$b/litegapps-prop )"
   	 for i in $(cat $BASE/modules/$b/litegapps-list); do
   	 	sedlog "- Restoring •> $S/$i"
    		dir1=`dirname $S/$i`
    		restore_file $S/$i
    		ch_con $dir1
  	   done
  	 fi
  done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
    print "Litegapps Controller addon.d"
  ;;
  post-restore)
    # Stub
  ;;
esac
