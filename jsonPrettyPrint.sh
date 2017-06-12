#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

JSON="$1"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "LOGFILE (optional - defaults to \$IMAGE-ewfverify.log)" && exit $COMMON_ERROR
fi

python -m json.tool "$JSON"
