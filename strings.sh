#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1
ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

RV=$COMMON_SUCCESS

INFO "Extracting strings for:"
for arg in "$@"; do
	if [ -e "$arg" ]; then
		OUTPUT="$arg-strings.txt"
		if [ -e "$OUTPUT" ]; then
			ERROR "Output file <$OUTPUT> already exists!"
		else
			INFO "$arg -> $OUTPUT"
			${BASH_SOURCE%/*}/strings_worker.sh "$arg" > "$OUTPUT"
			RV=$((RV+$?))
		fi
	else
		ERROR "File <$arg> does not exist!"
	fi
done

exit $RV

