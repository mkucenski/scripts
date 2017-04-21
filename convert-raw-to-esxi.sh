#!/bin/bash

RAW="$1"
VMDK="$2"

DEBUG=0
LOG="$VMDK.log"

if [ ! -e "$VMDK" ]; then
	/Applications/VirtualBox.app/Contents/MacOS/VBoxManage convertfromraw "$RAW" "$VMDK" --format VMDK --variant Fixed,ESX 2>&1 | tee -a "$LOG"
else
	echo "$0: Destination VMDK already exists!" | tee -a "$LOG"
fi

