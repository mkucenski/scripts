#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

SRCDIR="$1"
DSTBASEDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTBASEDIR" && exit $COMMON_ERROR
fi

function execRsync() {
	SRCDIR="$1"
	DSTBASEDIR="$2"
	SRCSUBDIR="$3"

	if [ -n "$SRCSUBDIR" ]; then
		SRCDIR="$SRCDIR/$SRCSUBDIR"
	fi

	ERR=0

	# rsync -av --fileflags "$SRCDIR" "$DSTBASEDIR/"
	rsync -av "$(NORMALIZEDIR "$SRCDIR")" "$(NORMALIZEDIR "$DSTBASEDIR")/"
	ERR=$(expr $ERR + $?)

	return $ERR
}

RV=$COMMON_SUCCESS

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTBASEDIR" ]; then
		INFO "--- $SRCDIR -> $DSTBASEDIR ---"
		execRsync "$SRCDIR" "$DSTBASEDIR"
		if [ $? -ne 0 ]; then
			ERROR "execRsync ($?)" "$0"
			RV=$COMMON_ERROR
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DSTBASEDIR> Not Available!" "$0"
		RV=$COMMON_ERROR
	fi
else
	ERROR "<$SRCDIR> Not Available!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

