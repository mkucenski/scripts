#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

MCT="$1"
if [ $# -eq 0 ]; then
	USAGE "MCT" && exit 1
fi

IMAGE_NAME="$(STRIP_EXTENSION "$(basename "$MCT")")"

$SEDCMD -r "s/\|(vol[[:digit:]]+[^|]+)\|/|$IMAGE_NAME\/\1|/" "$MCT"

