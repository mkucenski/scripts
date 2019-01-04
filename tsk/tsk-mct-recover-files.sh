#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCT_FILE="$4"
LOGFILE="$5"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "MCT" "LOGFILE" && exit 1
fi

START "$0" "$LOGFILE" "$*"

INFO "Finding unique inodes for extraction..." "$LOGFILE"
INODES="$(MKTEMP)"
CMD="grep -v \"|d/d\" \"$MCT_FILE\" | cut -d \"|\" -f 3 | sort -un > \"$INODES\""
EXEC_CMD "$CMD" "$LOGFILE"

mkdir -p "$DEST/_inodes"
mkdir -p "$DEST/_links"
while read INODE; do
	INFO "Extracting unique inode/file ($INODE)..." "$LOGFILE"
	ORIGINAL="$DEST/_inodes/$INODE"
	CMD="icat -o $OFFSET \"$IMAGE\" \"$INODE\" > \"$ORIGINAL\""
	EXEC_CMD "$CMD" "$LOGFILE"

	INFO "Finding MCT entries associated with inode ($INODE)..." "$LOGFILE"
	MCT_ENTRIES="$(MKTEMP)"
	REGEX="^[^|]*\|[^|]+\|$INODE\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$"
	egrep "$REGEX" "$MCT_FILE" > "$MCT_ENTRIES"

	INFO "Linking inode ($INODE) to various MCT filenames and paths..." "$LOGFILE"
	while read MCT_ENTRY; do
		FILEPATH="$(_tsk_mct_file "$MCT_ENTRY")"
		LINK="$DEST/_links/$FILEPATH"

		DIR="$(dirname "$FILEPATH")"
		mkdir -p "$DEST/_links/$DIR"

		CMD="ln \"$ORIGINAL\" \"$LINK\""
		EXEC_CMD "$CMD" "$LOGFILE"
	done < "$MCT_ENTRIES"

	rm "$MCT_ENTRIES"
	echo
done < "$INODES"

rm "$INODES"
END "$0" "$LOGFILE"
exit 0

