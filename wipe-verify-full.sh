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

BS=$("${BASH_SOURCE%/*}/blocksize.sh" "$DEVICE")

INFO "Verifying entire wiped device ($DEVICE) using (bs=$BS)..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs="$BS" | xxd -a)
INFO "$RESULTS" "$LOGFILE"

END "$0" "$LOGFILE"

