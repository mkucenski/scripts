#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

SRCDIR="$1"
DSTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTDIR" && exit $COMMON_ERROR
fi

function normalizeDir() {
	# rsync in particular operates differently depending on whether the source has a trailing '/';
	# this function normalizes directory names w/o the trailing '/'
	DIR=$(dirname "$1")/$(basename "$1")
	echo "$DIR"
}

function execRsync() {
	SRCDIR="$1"
	DSTDIR="$2"
	SRCSUBDIR="$3"

	ERR=0

	RESULT=$(execRsync2 "$SRCDIR/$SRCSUBDIR" "$DSTDIR")
	ERR=$(expr $ERR + $?)

	return $ERR
}

function execRsync2() {
	SRCDIR=$(normalizeDir "$1")
	DSTDIR=$(normalizeDir "$2")

	ERR=0

	# RESULT=$(rsync -av --fileflags "$SRCDIR" "$DSTDIR/")
	RESULT=$(rsync -av "$SRCDIR/" "$DSTDIR/")
	ERR=$(expr $ERR + $?)

	return $ERR
}

RV=$COMMON_SUCCESS

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTDIR" ]; then
		INFO "--- $SRCDIR -> $DSTDIR ---"
		RESULT=$(execRsync2 "$SRCDIR" "$DSTDIR")
		if [ $? -ne 0 ]; then
			ERROR "$RESULT ($?)" "$0"
			RV=$COMMON_ERROR
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DSTDIR> Not Available!" "$0"
		RV=$COMMON_ERROR
	fi
else
	ERROR "<$SRCDIR> Not Available!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

