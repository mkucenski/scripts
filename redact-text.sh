#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$1"
REDACT_LIST="$2"
PATTERN="$3"

if [ $# -eq 0 ]; then
	USAGE "FILE" "REDACT_LIST" "PATTERN"
	USAGE_DESCRIPTION "This script will perform a case-insensitive search for the strings found in <REDACT_LIST> and replace them with <PATTERN>."
	USAGE_EXAMPLE "$(basename "$0") <sensitive file> <redact list> \"[REDACTED]\""
	exit 1
fi

echo "Redacting keywords ($REDACT_LIST) from ($FILE)..."
REDACT_SED="$(MKTEMP)"
"$SEDCMD" -r "s/(.*)/s\/\1\/$PATTERN\/gI/" < "$REDACT_LIST" > "$REDACT_SED"

EXT="$(GET_EXTENSION "$FILE")"
"$SEDCMD" -r -f "$REDACT_SED" "$FILE" > "$(STRIP_EXTENSION "$FILE")_redacted.$EXT"

rm "$REDACT_SED"
