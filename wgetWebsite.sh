#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

SITE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SITE" "DESTDIR" && exit $COMMON_ERROR
fi

LOG="./$SITE.log"

RV=$COMMON_SUCCESS
START "$0" "$LOG" "$*"
LOG_VERSION "wget" "$(wget --version | head -n 1)" "$LOG"

if [ ! -e "$DESTDIR/$SITE" ]; then
	${BASH_SOURCE%/*}/whois.sh "$SITE" "$DESTDIR"
	${BASH_SOURCE%/*}/dig.sh "$SITE" "$DESTDIR"

	mkdir -p "$DESTDIR/$SITE"
	pushd "$DESTDIR/$SITE"

	# wget --recursive --level=1 --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --span-hosts --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"
	wget --recursive --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"

	popd
else
	ERROR "Site directory ($DESTDIR/$SITE) already exists!" "$0" "$LOG"
fi

END "$0" "$LOG"
exit $RV

