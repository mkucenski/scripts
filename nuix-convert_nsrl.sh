#!/bin/bash

FILE="$1"
DEST="$2"

TEMP=$(mktemp -t $(basename "$0") || exit 1)
TEMP2=$(mktemp -t $(basename "$0") || exit 1)

# Get rid of unicode characters that cause problems
$(dirname "$0")/convert2ascii.sh "$FILE" > "$TEMP"

# Trim out only the MD5 hash value
cut -d '"' -f 4 "$TEMP" > "$TEMP2"

# Sort only the unique values and remove the 'MD5' column header line
sort -u "$TEMP2" | sed '/MD5/d' > "$2"

# Delete temp files
rm "$TEMP"
rm "$TEMP2"

exit 0
