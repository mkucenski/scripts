#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

JSON="$1"
if [ $# -eq 0 ]; then
	USAGE "JSON" && exit 1
fi

python -m json.tool "$JSON"
