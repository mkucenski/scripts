#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1


IEFDIR="$1"
DESTDIR="$(FULL_PATH "$2")"
NAME="$3"
if [ $# -eq 0 ]; then
	USAGE "IEFDIR" "DESTDIR" "NAME" && exit 1
fi

LOGFILE="$DESTDIR/$NAME.log"

START "$0" "$LOGFILE" "$*"

pushd "$IEFDIR"
multi2mactime --type=ief --log="$LOGFILE" * > "$DESTDIR/$NAME.mct"
popd

END "$0" "$LOGFILE"

