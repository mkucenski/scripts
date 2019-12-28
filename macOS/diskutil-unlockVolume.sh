#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

LVUUID="$1"
PASSPHRASE="$2"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "MOUNT_POINT" && exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "This script can be used in conjunction with xargs to brute force a locked volume using a text file of possible passwords."
	USAGE_EXAMPLE "$(basename "$0") E7FD81B2-8C3E-414B-AB6F-4E246F4CFE1D \"password\""
	exit 1
fi

echo "Attempting passphrase: $PASSPHRASE"
if $(diskutil corestorage unlockVolume $LVUUID -passphrase "$PASSPHRASE"); then
	INFO "Successfully unlocked/mounted!"
	exit 0
else
	ERROR "Unable to unlock/mount!"
fi
