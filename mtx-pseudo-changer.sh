#!/bin/sh

#  Changer Command = "path-to-this-script/mtx-pseudo-changer %o %a %v %j %f %S"

wait=30

bconsole=`which bconsole`
mt=`which mt`
grep=`which grep`
sed=`which gsed`

command=$1
device=$2
volume=$3
job=$4
client=$5
slot=$6

logfile="/var/log/mtx-pseudo-changer.log"
log() {
	if [ -f $logfile ]; then
		echo "$*" > /dev/stderr
		echo "`date +\"%Y%m%d-%H:%M:%S\"` $*" >> $logfile
	fi
}

loadedvol=""
getloadedvol() {
	echo "mount" | $bconsole > /dev/null 2> /dev/null
	loadedvol=`echo "status storage" | $bconsole | $grep "$device" | $grep "is mounted with Volume=" | $sed -r 's/.*Volume=\"([^\"]+)\".*/\1/'`
	if [ -n "$loadedvol" ]; then
		log "getloadedvol() $device is loaded with <$loadedvol>."
		return
	else
		log "getloadedvol() $device is not currently loaded."
		return 1
	fi
}

unmountvol() {
	log "unmountvol() Unmounting volume."
	echo "unmount" | $bconsole > /dev/null 2> /dev/null
	$mt -f "$device" offline > /dev/null 2> /dev/null
	loadedvol=""
}

log "Params: <$command> <$device> <$volume> <$job> <$client> <$slot>"

case $command in 
	unload)
		log "unload) ..."
		unmountvol
		;;

	load)
		log "load) ..." 
		getloadedvol
		if [ $? -eq 0 ]; then
			if [ "$loadedvol" = "$volume" ]; then
				log "load) The requested volume <$volume> is already loaded."
				echo "$slot"
				exit 0
			else
				unmountvol
			fi
		fi
		# TODO An email should be sent at this point to let the user know what is needed.
		while [ 1 ]; do
			log "load) Waiting $wait sec. for <$volume> to be inserted."
			sleep $wait
			log "load) Calling getloadedvol() in loop..." 
			getloadedvol
			if [ $? -eq 0 ]; then
				if [ "$loadedvol" = "$volume" ]; then
					log "load) The requested volume <$volume> has been inserted."
					echo "$slot"
					exit 0
				else
					unmountvol
				fi
			fi
		done
		;;

	list) 
		# Pseudo changer has only one slot
		log "list) ..."
		echo "1"
		;;

	loaded)
		# Is this call asking if the tape is loaded in the changer or is it asking if the tape
		# is in the actual drive?
		log "loaded) ..."
		getloadedvol
		if [ $? -eq 0 ]; then
			if [ "$loadedvol" = "$volume" ]; then
				log "loaded) The requested volume <$volume> is already loaded in slot <$slot>."
				echo "1"	# Pseudo-changer device has only one slot, if the correct
						# volume is loaded, return slot 1
			#else
			#	unmountvol
			#	log "loaded) Unmounting the wrong volume and returning <0>."
			#	echo "0"	# Otherwise, return slot 0
			fi
		else
			log "loaded) Returning <0> because no volume is in the drive."
			echo "0"
		fi
		;;

	slots)
		# ...
		log "slots) ..."
		echo "1"
		;;
esac

exit 0

