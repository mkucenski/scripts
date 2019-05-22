#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

OLECF_FILE="$(FULL_PATH "$1")"

if [ $# -eq 0 ]; then
	USAGE "OLECF_FILE"
	USAGE_DESCRIPTION "This script will use the olecfexport utility (https://github.com/libyal/libolecf) to extract the contents of various OLE 2 Compound Files, including Outloook .msg file. It further attempts to parse/cleanup the extracted data for easier review."
	exit 1
fi

OLECF_LOG="$OLECF_FILE.log"
olecfexport -l "$OLECF_LOG" "$OLECF_FILE"
# ln -s "$OLECF_FILE.export/__substg1.0_64F00102/StreamData.bin" "$OLECF_FILE.export/headers.txt"

