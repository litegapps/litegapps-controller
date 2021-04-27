#!/sbin/sh
#
#Litegapps controller
#by wahyu6070
#
#. /tmp/backuptool.functions
log=/data/media/0/Android/litegapps/28-litegapps-controller.log
loglive=log=/data/media/0/Android/litegapps/28-litegapps-controller-live.log
base=/data/litegapps

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
	
printlog(){
	print "$1"
	if [ "$1" != " " ]; then
	echo "$1 [$(date '+%d/%m/%Y %H:%M:%S')]" >> $log
	echo "$1 [$(date '+%d/%m/%Y %H:%M:%S')]" >> $loglive
	else
	echo "$1" >> $log
	echo "$1" >> $loglive
	fi
	}
sedlog(){
	echo "[Processing]  $1 [$(date '+%d/%m/%Y %H:%M:%S')]" >> $log
	echo "[Processing]  $1 [$(date '+%d/%m/%Y %H:%M:%S')]" >> $loglive
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


case "$1" in
  backup)
  print "Litegapps Controller Backup"
  for b in $(ls -1 $base/modules); do
  	if [ -f $base/modules/$b/litegapps-list ]; then
   	 for i in $(cat $base/modules/$b/litegapps-list); do
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
  for b in $(ls -1 $base/modules); do
  	if [ -f $base/modules/$b/litegapps-list ]; then
  	[ -f $base/modules/$b/litegapps-prop ] && printlog "• Restoring •> $(getp package.name $base/modules/$b/litegapps-prop )"
   	 for i in $(cat $base/modules/$b/litegapps-list); do
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
