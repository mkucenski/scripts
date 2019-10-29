#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# DO NOT USE--DON"T FULLY UNDERSTAND THE RAMIFICATIONS OF THIS!

FILEPATH="$1"
if [ $# -eq 0 ]; then
	USAGE "FILEPATH" && exit 1
fi
LOGFILE="$(echo ~)/Logs/git.log"

CMD="git filter-branch --tree-filter 'rm -rf \"$FILEPATH\"' HEAD"
EXEC_CMD "$CMD" "$LOGFILE"

