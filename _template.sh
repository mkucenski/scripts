#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEST="$1"
if [ $# -eq 0 ]; then
	USAGE "DEST" "ARG(S)"
	exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "..."
	USAGE_EXAMPLE "$(basename "$0") ..."
	exit 1
fi

LOGFILE="$DEST/$(STRIP_EXTENSION "$(basename "$0")").log"
START "$0" "$LOGFILE" "$@"

shift
for ARG in $@; do
	# ...
done

END "$0" "$LOGFILE"

