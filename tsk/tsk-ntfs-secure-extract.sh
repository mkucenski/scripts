#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
MCT_GZ="$3"
OUTPUTDIR="$4"

# TODO This script has a bug: it accepts an offset for a specific volume, but doesn't recognize that multiple volumes may be shown in the MCT.GZ file.
# 			When it finds a second set of Secure entries in the MCT, it will attempt to extract based on the wrong offset.

if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "MCT.GZ" "OUTPUTDIR" && exit 1
	USAGE_DESCRIPTION ""
fi

IFS=$(echo -en "\n\b")

NAME="$(STRIP_EXTENSION $(basename "$IMAGE")) ($OFFSET)"
LOGFILE="$OUTPUTDIR/$NAME-Secure.log"
START "$0" "$LOGFILE" "$*"

SECURE_MCT="$(MKTEMP "$0" || exit 1)"
gunzip -c "$MCT_GZ" | grep -v '\$FILE_NAME' | grep '\$Secure' | "$SEDCMD" -r 's/\$//g; s/:/./g; s/\//-/g' > "$SECURE_MCT"

while read -r MCT_ENTRY; do
	INODE="$(_tsk_mct_inode "$MCT_ENTRY")"
	FILE="$(_tsk_mct_file "$MCT_ENTRY")"
	CMD="icat -o $OFFSET \"$IMAGE\" $INODE > \"$OUTPUTDIR/$NAME $FILE\""
	EXEC_CMD "$CMD" "$LOGFILE"
done < "$SECURE_MCT"

rm "$SECURE_MCT"

END "$0" "$LOGFILE"

