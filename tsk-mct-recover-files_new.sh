#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCT_FILE="$4"
LOGFILE="$5"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "MCT" "LOGFILE" && exit 1
fi

INODES=$(MKTEMP)
while read MCT_ENTRY; do
	if [ -n "$MCT_ENTRY" ]; then
		INODE="$(_tsk_mct_inode "$MCT_ENTRY" | grep "\-128\-1" | "$SEDCMD" -r 's/-128-1//')"
		# FILE="$(_tsk_mct_file "$MCT_ENTRY")"
		if [ -n "$INODE" ]; then
			# echo "$INODE: $FILE"
			echo "$INODE" >> "$INODES"
		fi
	fi
done < "$MCT_FILE"
TMP=$(MKTEMP)
sort -u "$INODES" > "$TMP" && mv "$TMP" "$INODES"

while read INODE; do
	grep "$INODE" "$MCT_FILE" | grep "\-128\-1"
done < "$INODES"

