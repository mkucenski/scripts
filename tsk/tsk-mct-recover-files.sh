#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCT_FILE="$4"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "MCT" && exit 1
fi

mkdir -p "$DEST"
LOGFILE="$DEST/$(STRIP_EXTENSION "$(basename "$0")").log"
START "$0" "$LOGFILE" "$*"

INFO "Finding unique inodes for extraction..." "$LOGFILE"
INODES="$(MKTEMP)"
CMD="grep -v \"|d/d\" \"$MCT_FILE\" | cut -d \"|\" -f 3 | sort -un > \"$INODES\""
EXEC_CMD "$CMD" "$LOGFILE"

mkdir -p "$DEST/_inodes"
while read INODE; do
	INFO "Extracting unique inode/file ($INODE)..." "$LOGFILE"
	ORIGINAL="$DEST/_inodes/$INODE"
	CMD="icat -o $OFFSET \"$IMAGE\" \"$INODE\" > \"$ORIGINAL\""
	EXEC_CMD "$CMD" "$LOGFILE"
done < "$INODES"

mkdir -p "$DEST/_files"
MCT_ENTRIES="$(MKTEMP)"
while read INODE; do
	ORIGINAL="$DEST/_inodes/$INODE"

	INFO "Finding MCT entries associated with inode ($INODE)..." "$LOGFILE"
	REGEX="^[^|]*\|[^|]+\|$INODE\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$"
	egrep "$REGEX" "$MCT_FILE" | tee "$MCT_ENTRIES" | tee -a "$LOGFILE"

	if [ -s "$MCT_ENTRIES" ]; then
		INFO "Linking inode ($INODE) to various MCT filenames and paths..." "$LOGFILE"
		while read MCT_ENTRY; do
			FILEPATH="$(_tsk_mct_file "$MCT_ENTRY")"
			FILE="$DEST/_files/$FILEPATH"
	
			DIR="$(dirname "$FILEPATH")"
			mkdir -p "$DEST/_files/$DIR"

			CMD="cp \"$ORIGINAL\" \"$FILE\""
			EXEC_CMD "$CMD" "$LOGFILE"
		done < "$MCT_ENTRIES"
		rm "$MCT_ENTRIES"
		rm "$ORIGINAL"
	else
		ERROR "No MCT entries found for inode ($INODE)!" "$LOGFILE"
	fi
done < "$INODES"
rm "$INODES"
rm -R "$DEST/_inodes"

NOTIFY "Finished recovery of $MCT_FILE ($IMAGE)!" "$0"
END "$0" "$LOGFILE"
exit 0

