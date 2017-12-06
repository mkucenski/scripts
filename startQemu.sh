#!/usr/bin/env bash

# Defaults
WRITABLE=0
MEMORY=512
SYSTEM=x86
CMD=qemu

# Command-line argument processing
while getopts "abc:hm:s:uw" OPTION; do
	case $OPTION in
		a)	ARGS="$ARGS -soundhw es1370"
	#	a)	ARGS="$ARGS -soundhw sb16"
			;;
		b)	ARGS="$ARGS -boot d"
			;;
		c)	ARGS="$ARGS -cdrom $OPTARG"
			;;
		m)	MEMORY="$OPTARG"
			;;
		s)	SYSTEM="$OPTARG"
			;;
		u)	ARGS="$ARGS -usb"
			;;
		w)	WRITABLE=1
			;;
		*h) 	echo "usage: `basename $0` [-acmuw] file"
			echo "       a : enable audio"
			echo "       b : boot cdrom"
			echo "       c : path to cdrom (device|file)"
			echo "       m : memory size (defaults to 512)"
			echo "       s : system (x86|sparc|ppc) (defaults to x86)"
			echo "       u : enable usb"
			echo "       w : writable (defaults to snapshot mode)"
			echo "       file : file to process (defaults to stdin)"
			exit 1
			;;
	esac
done
shift $(($OPTIND - 1))

if [ -n "$1" ]; then
	if [ $WRITABLE != 1 ]; then
		ARGS="$ARGS -snapshot"
	fi

	if [ $SYSTEM = "sparc" ]; then
		CMD=qemu-system-sparc
	elif [ $SYSTEM = "ppc" ]; then
		CMD=qemu-system-ppc
	else
		ARGS="$ARGS -kernel-kqemu"
	fi

	sudo $CMD $ARGS -m $MEMORY -net nic -net tap,script=`dirname $0`/freebsdQemuBridge.sh "$1"
else
	echo "Error! Missing image file name."
	exit 0
fi

