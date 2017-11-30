#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SITE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SITE" "DESTDIR" && exit $COMMON_ERROR
fi

SITE_STRIPPED="$(echo "$SITE" | $SEDCMD -r -f "${BASH_SOURCE%/*}/sed/url-strip-to-filename.sed")"

RV=$COMMON_SUCCESS

if [ ! -e "$DESTDIR/$SITE_STRIPPED" ]; then
	mkdir -p "$DESTDIR/$SITE_STRIPPED"
	pushd "$DESTDIR/$SITE_STRIPPED"

	LOG="./$SITE_STRIPPED.log"
	START "$0" "$LOG" "$*"
	LOG_EXEC_VERSION "wget" "$(wget --version | grep "GNU Wget")" "$LOG"

	# Save whois/dig records for specified site
	${BASH_SOURCE%/*}/whois.sh "$SITE_STRIPPED" ./
	${BASH_SOURCE%/*}/dig.sh "$SITE_STRIPPED" ./

	# wget --recursive --level=1 --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --span-hosts --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"
	wget --recursive --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"

	popd

	# Hash/archive results for retention
	"${BASH_SOURCE%/*}/fciv_archive.sh" "$DESTDIR/$SITE_STRIPPED" 0 "$DESTDIR/$SITE_STRIPPED.7z"

	END "$0" "$LOG"
else
	ERROR "Site directory ($DESTDIR/$SITE_STRIPPED) already exists!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

