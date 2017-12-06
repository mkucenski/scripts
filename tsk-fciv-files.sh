#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
DOSHA1="$3"
LOGFILE="$4"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DOSHA1" "LOGFILE" && exit 1
fi

KEY="1.75"

MCT=$(MKTEMP "$0" || exit 1)
INFO "Building List of All Files Found in Image/Device... ($MCT)"
fls -o $OFFSET -m "" -F -r "$IMAGE" | $SEDCMD -r 's/^([[:digit:]]+\|)\/?/\1/' > "$MCT"

UNSORTED=$(MKTEMP "$0" || exit 1)
INFO "Extracting and Hashing Each File... ($UNSORTED)"
while read LINE; do
	if [ -n "$LINE" ]; then
		FILE=$(_tsk_mct_file "$LINE")
		INODE=$(_tsk_mct_inode "$LINE")
		if [ -n "$FILE" ]; then
			if [ -n "$INODE" ]; then
				icat -o $OFFSET "$IMAGE" $INODE 2> >(tee -a "$LOGFILE" >&2) | ${BASH_SOURCE%/*}/fciv_worker_stdin.sh "$FILE" $DOSHA1 2> >(tee -a "$LOGFILE" >&2) >> "$UNSORTED"
	 		fi
		fi
	else
		ERROR "Read invalid line!" "$0" && exit 1
	fi
done < "$MCT"

INFO "Sorting Based on File Name..."
${BASH_SOURCE%/*}/fciv.sh 
sort --key=$KEY "$UNSORTED"

rm "$MCT"
rm "$UNSORTED"

