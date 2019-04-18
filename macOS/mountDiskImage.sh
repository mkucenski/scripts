#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

IMAGE="$1"
MOUNT_POINT="$2"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "MOUNT_POINT" && exit 1
fi

if [ -e "$IMAGE" ]; then
	mkdir -p "$MOUNT_POINT"
	ewfmount -X allow_other "$IMAGE" "$MOUNT_POINT"
	hdiutil attach -readonly -imagekey diskimage-class=CRawDiskImage "$MOUNT_POINT/ewf1"
else
	ERROR "Image file <$IMAGE> does not exist!" "$0"
fi

