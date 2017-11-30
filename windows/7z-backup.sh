#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

SRCDIR="$1"
DSTDIR="$2"
DSTNAME="$3"

if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTDIR" "DSTNAME" && exit $COMMON_ERROR
fi

FULLBACKUP="$DSTDIR/$DSTNAME.7z"

RV=$COMMON_SUCCESS
LOCK

if [ ! -e "$FULLBACKUP" ]; then
	# Do full backup to create a base archive
	7z a "$FULLBACKUP" "$SRCDIR"
else
	# Do differential backup to update base archive
	7z u "$FULLBACKUP" "$SRCDIR" -u- -up0q3r2x2y2z0w2!"$(STRIP_EXTENSION "$FULLBACKUP") $(DATE) $(TIME).7z"
fi

echo "Press any key to continue..."
read

UNLOCK
exit $RV

