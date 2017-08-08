#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

DIR="$1"
DOSHA1="$2"
ARCHIVE="$3"
if [ $# -ne 3 ]; then
	USAGE "DIR" "DOSHA1" "ARCHIVE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

HASHES="$(STRIP_EXTENSION "$ARCHIVE").md5"

INFO "Hashing source files into <$HASHES>..."
${BASH_SOURCE%/*}/fciv_recursive.sh "$DIR" $DOSHA1 > "$HASHES"

INFO "Archiving source files into <$ARCHIVE>..."
7z a "$ARCHIVE" "$DIR"

INFO "Hashing archive file into <$HASHES>..."
${BASH_SOURCE%/*}/fciv_worker.sh "$ARCHIVE" $DOSHA1 >> "$HASHES"

exit $RV

