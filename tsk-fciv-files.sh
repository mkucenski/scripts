#!/bin/bash
. $(dirname "$0")/common-include.sh
. $(dirname "$0")/tsk-include.sh

IMAGE="$1"
OFFSET="$2"
DOSHA1="$3"

KEY="1.75"

MCT=$(mktemp -t $(basename "$0") || exit 1)
INFO "Building List of All Files Found in Image/Device... ($MCT)"
fls -o $OFFSET -m "" -F -r "$IMAGE" | $SEDCMD -r 's/^([[:digit:]]+\|)\/?/\1/' > "$MCT"

$(dirname "$0")/fciv.sh 
UNSORTED=$(mktemp -t $(basename "$0") || exit 1)
INFO "Extracting and Hashing Each File... ($UNSORTED)"
while read LINE; do
	if [ -n "$LINE" ]; then
		FILE=$(_tsk_mct_file "$LINE")
		INODE=$(_tsk_mct_inode "$LINE")
		if [ -n "$FILE" ]; then
			if [ -n "$INODE" ]; then
				icat -o $OFFSET "$IMAGE" $INODE | $(dirname "$0")/fciv_worker_stdin.sh "$FILE" $DOSHA1 | tee -a "$UNSORTED" > /dev/stderr 
	 		fi
		fi
	else
		ERROR "Read invalid line!" "$0"
	fi
done < "$MCT"

INFO "Sorting Based on File Name..."
sort --key=$KEY "$UNSORTED"
