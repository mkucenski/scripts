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
	LOG="$(FULL_PATH "$DESTDIR")/$SITE_STRIPPED/$SITE_STRIPPED.log"
	START "$0" "$LOG" "$*"

	pushd "$DESTDIR/$SITE_STRIPPED"

	LOG_VERSION "wget" "$(wget --version | grep "GNU Wget")" "$LOG"

	# Save whois/dig records for specified site
	${BASH_SOURCE%/*}/whois.sh "$SITE_STRIPPED" ./
	${BASH_SOURCE%/*}/dig.sh "$SITE_STRIPPED" ./

	# wget --recursive --level=1 --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --span-hosts --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"
	wget --recursive --level=1 --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"

	# Hash results for retention
	"${BASH_SOURCE%/*}/fciv_recursive.sh" ./ 0 > "./$SITE_STRIPPED.md5"

	popd

	# Archive results
 	ARCHIVE="$DESTDIR/${SITE_STRIPPED}_$(DATE).7z"
	7z a "$ARCHIVE" "$DESTDIR/$SITE_STRIPPED"
	"${BASH_SOURCE%/*}/fciv.sh" "$ARCHIVE" > "$ARCHIVE.md5"

	END "$0" "$LOG"
else
	ERROR "Site directory ($DESTDIR/$SITE_STRIPPED) already exists!" "$0" && exit 1
fi

