#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

MSG="$(FULL_PATH "$1")"

olecfexport "$MSG"
ln -s "$MSG.export/__substg1.0_64F00102/StreamData.bin" "$MSG.export/headers.txt"

