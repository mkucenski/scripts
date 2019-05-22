#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE=$1; shift
if [ $# -eq 0 ]; then
	USAGE "FILE" "TERMS..." && exit 1
fi

if [ -e "$FILE" ]; then
	TEMP=$(MKTEMP "$0" || exit 1)

	echo "$FILE:"
	for TERM in $@; do
		COUNT=$(grep -i "$TERM" "$FILE" | cat -n | tail -n 1 | cut -f 1 | gsed -r 's/[[:space:]]+//g')
		echo "$TERM:	$COUNT" >> "$TEMP"
	done

	sort --numeric-sort --reverse --field-separator=":" --key=2 "$TEMP"

	rm "$TEMP"
fi

