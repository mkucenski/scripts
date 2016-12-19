#!/bin/bash

VMDK="$1"
RAW="$2"

DEBUG=0
LOG="$RAW.log"

if [ ! -e "$RAW" ]; then
	qemu-img convert -f vmdk "$VMDK" -O raw "$RAW" 2>&1 | tee -a "$LOG"
else
	echo "$0: Destination RAW already exists!" | tee -a "$LOG"
fi

#!/bin/bash



