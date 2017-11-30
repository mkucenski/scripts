#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SCRIPT="$1"
if [ $# -ne 1 ]; then
	USAGE "SCRIPT" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

TYPE="$(basename "$(grep "\#\!" "$SCRIPT" | $SEDCMD -r 's/\#\!(.*)/\1/')")"

echo
echo "**$(basename "$SCRIPT"):**"
echo
echo "~~~$TYPE"
# $SEDCMD -r 's/^(.*)$/    \1/' "$SCRIPT"
cat "$SCRIPT"
echo "~~~"

exit $RV

