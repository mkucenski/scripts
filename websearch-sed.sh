#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SEARCH_FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "SEARCH_FILE" && exit 1
fi

SCRIPT_FILES=""
for SED in ${BASH_SOURCE%/*}/sed/*_search.sed; do
	SCRIPT_FILES="$SCRIPT_FILES -f \"$SED\""
done

CMD="\"$SEDCMD\" -r$SCRIPT_FILES \"$SEARCH_FILE\""
eval "$CMD" | sort -u

