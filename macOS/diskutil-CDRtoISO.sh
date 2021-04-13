#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

INPUT_CDR="$1"
OUTPUT_ISO="$2"
if [ $# -eq 0 ]; then
	USAGE "INPUT_CDR" "OUTPUT_ISO" && exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION ""
	USAGE_EXAMPLE "$(basename "$0") "
	exit 1
fi

hdiutil makehybrid -iso -joliet -o "$OUTPUT_ISO" "$INPUT_CDR"
