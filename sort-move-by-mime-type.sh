#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Based on: https://www.cgsecurity.org/wiki/After_Using_PhotoRec#Using_a_shell_script_for_Mac_OS_X_and_Linux

RECUP_DIR="$(FULL_PATH "$1")"
if [ $# -eq 0 ]; then
	USAGE "RECUP_DIR" && exit 1
fi

TARGET_DIR="$RECUP_DIR.by_ext"
INFO "Sorting <$RECUP_DIR> by extension into <$TARGET_DIR>..."
find "$RECUP_DIR" -type f | while read FILE; do
	FILE_NAME="$(basename "$FILE")"
	if [ "$FILE_NAME" != "report.xml" ]; then
		FILE_EXT="${FILE##*.}";
		EXTENSION_DIR="$TARGET_DIR/$FILE_EXT";
		if [ ! -d "$EXTENSION_DIR" ]; then
			echo "$EXTENSION_DIR"
			mkdir -p "$EXTENSION_DIR";
 		fi
		mv -vn "$FILE" "$EXTENSION_DIR/"
	fi
done 

