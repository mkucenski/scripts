#!/usr/local/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

DEST="$1"
if [ $# -eq 0 ]; then
	USAGE "DEST" && exit $COMMON_ERROR
fi

# extract via: cd "$NEWDST" &&  bunzip2 -c "$DEST" | restore -r -f 

dump -L0af - / | bzip2 -c > "$DEST"
exit $?

