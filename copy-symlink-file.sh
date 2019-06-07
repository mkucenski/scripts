#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

LINK="$1"
if [ $# -eq 0 ]; then
	USAGE "LINK"
	USAGE_DESCRIPTION "For a given symbolic link, remove the link and copy the target file to it's place."
	exit 1
fi

TARGET="$(readlink "$LINK")"
if [ -n "$TARGET" ]; then
	rm "$LINK"
	cp "$TARGET" "$LINK"
else
	ERROR "Unable to read link target!" "$0"
fi

