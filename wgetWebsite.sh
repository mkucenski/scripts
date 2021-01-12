#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SITE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SITE" "DESTDIR" && exit 1
fi

SITE_STRIPPED="$(echo "$SITE" | $SEDCMD -r -f "${BASH_SOURCE%/*}/sed/url-strip-to-filename.sed")"

if [ ! -e "$DESTDIR/$SITE_STRIPPED" ]; then
	mkdir -p "$DESTDIR/$SITE_STRIPPED"
	LOGFILE="$(FULL_PATH "$DESTDIR")/$SITE_STRIPPED/$SITE_STRIPPED.log"
	START "$0" "$LOGFILE" "$*"

	pushd "$DESTDIR/$SITE_STRIPPED"

	LOG_VERSION "wget" "$(wget --version | grep "GNU Wget")" "$LOGFILE"

	# This script needs constant adjustment, largely around "--span-hosts" and "--level"
	# 		In many cases, you really can't leave level off while also doing --span-hosts or it will download forever...
	# 		W/o span-hosts, you can skip level, but you run the risk of not downloading hosted images/content that are integral to the site...
	# 		The two options have to be balanced appropriately for the given site and your download needs.

	#CMD="wget --recursive --level=1 --span-hosts --append-output \"$LOGFILE\" --show-progress -t 3 --user-agent=\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17\" --adjust-extension --page-requisites --server-response --convert-links --backup-converted \"$SITE\""
	CMD="wget --recursive --append-output \"$LOGFILE\" --show-progress -t 3 --user-agent=\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17\" --adjust-extension --page-requisites --server-response --convert-links --backup-converted \"$SITE\""
	EXEC_CMD "$CMD" "$LOGFILE"

	# Hash results for retention
	"${BASH_SOURCE%/*}/fciv_recursive.sh" ./ 0 > "./$SITE_STRIPPED.md5"

	popd

	END "$0" "$LOGFILE"
else
	ERROR "Site directory ($DESTDIR/$SITE_STRIPPED) already exists!" "$0" && exit 1
fi

