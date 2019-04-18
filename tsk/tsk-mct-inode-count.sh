#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

# MCT_FILE="$1"
# if [ $# -eq 0 ]; then
# 	USAGE "MCT" && exit 1
# fi

grep -v "|d/d" < /dev/stdin | cut -d "|" -f 3 | sort -un | wc -l | "$SEDCMD" -r 's/[[:space:]]+//g'

