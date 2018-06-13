#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "FILE" && exit 1
fi

echo $(FULL_PATH "$FILE")

