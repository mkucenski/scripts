#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

JSON="$1"
if [ $# -eq 0 ]; then
	USAGE "JSON" && exit $COMMON_ERROR
fi

python -m json.tool "$JSON"
