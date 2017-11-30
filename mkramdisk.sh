#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

GBYTES="$1"
MOUNTPOINT="$2"
if [ $# -eq 0 ]; then
	USAGE "SIZE (GB)" "MOUNT POINT" && exit 1
fi

SECTORS=$(($GBYTES * 1024 * 1024 * 1024 / 512))
UNAME=$(uname)
if [ "$UNAME" = "Darwin" ]; then
	RAMDEVICE=$(hdiutil attach -nomount ram://$SECTORS)
	if [ -n "$RAMDEVICE" ]; then
		RV=$(newfs_hfs $RAMDEVICE)
		if [ -n "$RV" ]; then
			mkdir -p "$MOUNTPOINT"

			RV=$(diskutil mount -mountPoint "$MOUNTPOINT" $RAMDEVICE)
			if [ -n "$RV" ]; then
				echo "$RAMDEVICE"
			else
				ERROR "Unable to mount $RAMDEVICE ($RV)!" "$0"
				${BASH_SOURCE%/*}/rmramdisk.sh "$RAMDEVICE"
				exit 1
			fi
		else
			ERROR "Unable to HFS format $RAMDEVICE ($RV)!" "$0"
			${BASH_SOURCE%/*}/rmramdisk.sh "$RAMDEVICE"
			exit 1
		fi
	else
		ERROR "Unable to create RAM device via <hdiutil attach>!" "$0" && exit 1
	fi
else
	ERROR "Undefined OS, unable to create ram disk!" "$0" && exit 1
fi

