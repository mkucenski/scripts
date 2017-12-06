#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIALNUM" "LOGDIR" && exit 1
fi

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE" "$*"

DISKINFO="$(${BASH_SOURCE%/*}/diskinfo.sh "$DEVICE")"
INFO "$DISKINFO" "$LOGFILE"

COUNT=1024
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Wiping device ($DEVICE)..." "$LOGFILE"

${BASH_SOURCE%/*}/wipe-disk_worker.sh "$DEVICE" "$LOGFILE"

INFO "Completed wiping device ($DEVICE)!" "$LOGFILE"

${BASH_SOURCE%/*}/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"

