#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILELIST="$1"
if [ $# -eq 0 ]; then
	USAGE "FILELIST" && exit 1
fi

vi $(cat "$FILELIST")

