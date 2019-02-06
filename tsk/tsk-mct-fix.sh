#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

MCT="$1"
IDENTIFIER="$2"
if [ $# -eq 0 ]; then
	USAGE "MCT" "IDENTIFIER" && exit 1
fi

$SEDCMD -r "s/\|(vol[[:digit:]]+[^|]+)\|/|$IDENTIFIER\/\1|/" "$MCT"

