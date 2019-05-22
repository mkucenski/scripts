#!/bin/ash

VMDK_DIR="$1"
RAW_DEVICE="$2"
if [ $# -eq 0 ]; then
	echo "Usage: $(basename "$0") <VMDK_DIR> <RAW_DEVICE (e.g. /vmfs/devices/disks/t10.ATA...)>" && exit 0
fi

vmkfstools "$VMDK_DIR/$(basename "$RAW_DEVICE").vmdk" -z "$RAW_DEVICE"

