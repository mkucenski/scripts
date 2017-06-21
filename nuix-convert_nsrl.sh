#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

FILE="$1"
DEST="$2"
if [ $# -eq 0 ]; then
	USAGE "FILE" "DEST" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

TEMP=$(MKTEMP "$0" || exit $COMMON_ERROR)
TEMP2=$(MKTEMP "$0" || exit $COMMON_ERROR)

# Get rid of unicode characters that cause problems
${BASH_SOURCE%/*}/convert2ascii.sh "$FILE" > "$TEMP"

# Trim out only the MD5 hash value
cut -d '"' -f 4 "$TEMP" > "$TEMP2"

# Sort only the unique values and remove the 'MD5' column header line
sort -u "$TEMP2" | sed '/MD5/d' > "$2"

# Delete temp files
rm "$TEMP"
rm "$TEMP2"

exit $RV

