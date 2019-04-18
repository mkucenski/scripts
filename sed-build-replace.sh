#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

REPL="$1"

if [ $# -eq 0 ]; then
	USAGE "REPL" && exit 1
	USAGE_DESCRIPTION "This script builds a sed script for replacing various instances of something (input via STDIN) with a replacement string (REPL)."
fi

"$SEDCMD" -r "s/^(.*)$/s\/\1\/$REPL\//" < /dev/stdin

