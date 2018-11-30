#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

cat /dev/stdin | cut -d "|" -f 2 | egrep -vi "(\((\\\$FILE_NAME|deleted)\)|:Zone\.Identifier)"

