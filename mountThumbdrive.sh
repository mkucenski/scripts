#!/usr/bin/env bash

if [ "$1" = "-d" ]; then
	DEVICE=$2
	sudo umount /media/thumbdrive-$DEVICE
	rmdir /media/thumbdrive-$DEVICE
else
	if [ "$1" = "-ro" ]; then
		DEVICE=$2
		mkdir -p /media/thumbdrive-$DEVICE
		sudo mount -t msdos -o ro /dev/$DEVICE /media/thumbdrive-$DEVICE
	else
		DEVICE=$1
		mkdir -p /media/thumbdrive-$DEVICE
		sudo mount -t msdos /dev/$DEVICE /media/thumbdrive-$DEVICE
	fi
fi

