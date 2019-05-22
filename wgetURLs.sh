#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

URLLIST="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "URLLIST" "DESTDIR" && exit 1
fi

BASENAME="$(STRIP_EXTENSION "$(basename "$0")")_$(DATE)"
LOGFILE="$(FULL_PATH "$DESTDIR")/$BASENAME.log"
START "$0" "$LOGFILE" "$*"

LOG_VERSION "wget" "$(wget --version | grep "GNU Wget")" "$LOGFILE"

while read -r URL; do
	DOMAIN="$(echo "$URL" | $SEDCMD -r -f "${BASH_SOURCE%/*}/sed/domain.sed")"
	mkdir -p "$DESTDIR/$BASENAME/$DOMAIN" 
	pushd "$DESTDIR/$BASENAME/$DOMAIN" >/dev/null

	CMD="wget --append-output \"../$DOMAIN.log\" --show-progress -t 3 --user-agent=\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17\" --adjust-extension --server-response \"$URL\""
	EXEC_CMD "$CMD" "$LOGFILE"

	popd >/dev/null
done < "$URLLIST"

pushd "$DESTDIR/$BASENAME" >/dev/null
# Hash results for retention
"${BASH_SOURCE%/*}/fciv_recursive.sh" ./ 0 > "../$BASENAME.md5"
popd >/dev/null

pushd "$DESTDIR" >/dev/null
# Archive results
ARCHIVE="$BASENAME.7z"
7z a "$ARCHIVE" "$BASENAME"
"${BASH_SOURCE%/*}/fciv.sh" "$ARCHIVE" > "$ARCHIVE.md5"
popd >/dev/null

END "$0" "$LOGFILE"

