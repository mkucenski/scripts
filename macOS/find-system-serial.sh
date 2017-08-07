#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

DESTDIR="$1"
if [ $# -ne 1 ]; then
	USAGE "DESTDIR" && exit $COMMON_ERROR
fi

ROOT_USER_CACHE="/private/var/folders/zz/zyxvpxvq6csfxvn_n00000sm00006d/C"

FILE="$ROOT_USER_CACHE/consolidated.db"
BASE="$(STRIP_EXTENSION "$(basename "$FILE")")"
INFO "$FILE..."
${BASH_SOURCE%/*}/../sqlite-dump-csv.sh "$FILE" "$DESTDIR/$BASE.csv"

FILE="$ROOT_USER_CACHE/cache_encryptedA.db"
BASE="$(STRIP_EXTENSION "$(basename "$FILE")")"
INFO "$FILE..."
${BASH_SOURCE%/*}/../sqlite-dump-csv.sh "$FILE" "$DESTDIR/$BASE.csv"

FILE="$ROOT_USER_CACHE/lockCache_encryptedA.db"
BASE="$(STRIP_EXTENSION "$(basename "$FILE")")"
INFO "$FILE..."
${BASH_SOURCE%/*}/../sqlite-dump-csv.sh "$FILE" "$DESTDIR/$BASE.csv"

