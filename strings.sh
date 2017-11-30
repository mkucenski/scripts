#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

INFO "Extracting strings for:"
for arg in "$@"; do
	if [ -e "$arg" ]; then
		OUTPUT="$arg-strings.txt"
		# if [ -e "$OUTPUT" ]; then
		# 	ERROR "Output file <$OUTPUT> already exists!" && exit 1
		# else
			INFO "$arg -> $OUTPUT"
			${BASH_SOURCE%/*}/strings_worker.sh "$arg" > "$OUTPUT"
		# fi
	else
		ERROR "File <$arg> does not exist!" && exit 1
	fi
done

