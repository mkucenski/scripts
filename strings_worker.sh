#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
export LC_ALL='C'

FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "FILE" && exit 1
fi

# --encoding=encoding
# 		Select the character encoding of the strings that are to be found.  Possible values for encoding are: 
# 			s = single-7-bit-byte characters (ASCII, ISO 8859, etc., default), 
# 			S = single-8-bit-byte characters, 
# 			b = 16-bit bigendian, 
# 			l = 16-bit littleendian, 
# 			B = 32-bit bigendian, 
# 			L = 32-bit littleendian.
# 		Useful for finding wide character strings. (l and b apply to, for example, Unicode UTF-16/UCS-2 encodings).

TMP=$(MKTEMP "$0" || exit 1)
gstrings -t x -e s "$FILE" > "$TMP"
gstrings -t x -e S "$FILE" > "$TMP"
gstrings -t x -e l "$FILE" >> "$TMP"
gstrings -t x -e L "$FILE" >> "$TMP"
gsort -u -k 1 "$TMP"
rm "$TMP"

