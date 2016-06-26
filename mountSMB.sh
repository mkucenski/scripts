#!/bin/sh

if [ "$1" = "-d" ]; then
	SERVER=$2
	SHARE=$3
	sudo umount /media/$SERVER-$SHARE
	rmdir /media/$SERVER-$SHARE
else
	SERVER=$1
	SHARE=$2
	USER=`whoami`
	mkdir -p /media/$SERVER-$SHARE
	#sudo chown root:$USER /media/$SERVER-$SHARE
	sudo mount -t smbfs //$USER@$SERVER/$SHARE /media/$SERVER-$SHARE
fi

