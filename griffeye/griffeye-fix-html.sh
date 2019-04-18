#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

# Griffeye Analyze DI spits out HTML reports that have thumbnails which are too small for easy viewing; make them larger.

HTML_DIR="$1"
if [ $# -eq 0 ]; then
	USAGE "HTML_DIR" && exit 1
fi

TEMP=$(MKTEMP "$0" || exit 1)

mkdir -p "bak"
for HTML_FILE in $HTML_DIR/*.html; do 
	INFO "Processing File: $HTML_DIR/$HTML_FILE..."
	if [ ! -e "./bak/$HTML_FILE.bak" ]; then
		cp "$HTML_FILE" "./bak/$HTML_FILE.bak"
	fi
	gsed -r 's/height="[[:digit:]]+"/height="128"/g; s/max-height: 64px; //g;' "$HTML_FILE" > "$TEMP"
	cp "$TEMP" "$HTML_FILE"
done

rm "$TEMP"

