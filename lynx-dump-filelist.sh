#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# FILELIST="$1"
# if [ $# -eq 0 ]; then
# 	USAGE "FILELIST" && exit $COMMON_ERROR
# fi

# lynx -dump $(cat "$FILELIST")
lynx -dump $(cat "${1:-/dev/stdin}")

