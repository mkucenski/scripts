#!/usr/bin/env bash

# Defaults
DETACH=0
WRITABLE=0

# Command-line argument processing
while getopts "dwh" OPTION; do
	case $OPTION in
		d)	DETACH=1
			;;
		w)	WRITABLE=1
			;;
		*h) 	echo "usage: `basename $0` [-dw] file"
			echo "       d : detach a previously connected image"
			echo "       w : writable (defaults to read-only)"
			echo "       file : image file to mount or device to detach"
			exit 1
			;;
	esac
done
shift $(($OPTIND - 1))

if [ -n "$1" ]; then
	if [ $DETACH != 1 ]; then
		#sudo mdconfig -a -t vnode -f image.dd -o readonly
		ARGS="-a -t vnode -f $1"

		if [ $WRITABLE != 1 ]; then
			ARGS="$ARGS -o readonly"
		fi
	else
		#sudo mdconfig -d -u md0
		ARGS="-d -u $1"
	fi

	sudo mdconfig $ARGS
else
	echo "Error! Missing image file or device name."
	exit 0
fi

