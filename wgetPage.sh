#!/bin/bash

# The goal of this script is to capture a useable copy of an Internet website for retention/evidence.

SITE="$1"
DEST="$2"
LOG="./$SITE.log"

mkdir -p "$DEST/$SITE"
pushd "$DEST/$SITE"

~/Scripts/whois.sh "$SITE" ./

torify wget -e robots=off --span-hosts --wait 0.25 --recursive --level=1 --append-output "$LOG" --show-progress -t 3 --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" --adjust-extension --page-requisites --server-response --convert-links --backup-converted "$SITE"

echo "Script Code --------------------------------------------------" >> "$LOG"
cat "$0" >> "$LOG"
echo "Script Code --------------------------------------------------" >> "$LOG"

echo "" >> "$LOG"

echo "Software Versions --------------------------------------------------" >> "$LOG"
uname -v >> "$LOG"
wget --version >> "$LOG"
echo "Software Versions --------------------------------------------------" >> "$LOG"

popd

