#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE=$1
if [ $# -eq 0 ]; then
	USAGE "FILE"
	exit 1
fi

MIME_EXT="$(file --extension "$FILE" | $SEDCMD -r 's/^.+:[[:space:]]+([^\/]+).*$/\1/')"
echo -n "$MIME_EXT: $FILE"
if [ "$MIME_EXT" != "???" ]; then
	OLD_EXT="$(GET_EXTENSION "$FILE")"
	if [ "$MIME_EXT" != "$OLD_EXT" ]; then
		NEW="$FILE.$MIME_EXT"
		echo -n " $NEW"
		mv "$FILE" "$NEW"
	fi
fi
echo

