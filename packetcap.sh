#!/usr/local/bin/bash

if [ -z $1 ]; then
	echo "Missing interface name. (e.g. packetcap.sh fxp1)"
else
	interface=$1
	dumpcap -i $interface -w /usr/local/var/packetcap/dumpcap_$interface -a filesize:125000 -b files:20 > /dev/null 2>&1 &
	echo $! > /var/run/dumpcap_$interface.pid
fi

