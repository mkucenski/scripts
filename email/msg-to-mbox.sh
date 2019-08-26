#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

DEST="$1"; shift
if [ $# -eq 0 ]; then
	USAGE "DEST EML_FILE(S)" && exit 1
fi

# ls ../*.msg | xargs -I {} msgconvert --mbox ./{}.eml {}
for X in $@; do
	echo "$X:"
	msgconvert --mbox "$(STRIP_EXTENSION "$X").mbox" "$X"
done
