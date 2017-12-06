#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# The goal of this script is to capture a useable copy of an Internet website for retention/evidence.

DOMAIN="$1"
DEST="$2"
LOGFILE="$DEST/$DOMAIN-wget.log"
if [ $# -eq 0 ]; then
	USAGE "DOMAIN" "DEST" && exit 1
fi

START "$0" "$LOGFILE" "$*"

${BASH_SOURCE%/*}/whois.sh "$DOMAIN" "$DEST"

mkdir -p "$DEST/$DOMAIN"
pushd "$DEST/$DOMAIN"

torify wget -e robots=off --span-hosts --wait 0.25 --recursive --level=1 --append-output "$LOGFILE" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$DOMAIN"

echo "Script Code --------------------------------------------------" >> "$LOGFILE"
cat "$0" >> "$LOGFILE"
echo "Script Code --------------------------------------------------" >> "$LOGFILE"

echo "" >> "$LOGFILE"

echo "Software Versions --------------------------------------------------" >> "$LOGFILE"
uname -v >> "$LOGFILE"
wget --version >> "$LOGFILE"
echo "Software Versions --------------------------------------------------" >> "$LOGFILE"

popd


END "$0" "$LOGFILE"

