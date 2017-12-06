#!/usr/bin/env bash

SRCFILE="$1"
DESTROOT="$2"

if [ -e "$SRCFILE" ]; then
	SRCNAME=`basename "$SRCFILE"`
	SRCPATH=`dirname "$SRCFILE"`
	SRCMD5=`md5 -q "$SRCFILE"`

	if mkdir -p "$DESTROOT/$SRCPATH"; then
		cp -n "$SRCFILE" "$DESTROOT/$SRCPATH/"
		DESTMD5=`md5 -q "$DESTROOT/$SRCPATH/$SRCNAME"`
		if [ "$SRCMD5" = "$DESTMD5" ]; then
			echo "MD5 Verified ($DESTROOT/$SRCPATH/$SRCNAME) = $SRCMD5"
			exit 1
		else
			echo "MD5 Mismatch ($DESTROOT/$SRCPATH/$SRCNAME) != $SRCMD5"
			rm "$DESTROOT/$SRCPATH/$SRCNAME"
		fi
	fi
else
	echo "ERROR: <$SRCFILE> does not exist!"
fi

exit 0
