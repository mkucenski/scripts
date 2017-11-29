#!/bin/bash

SRCDIR="$1"
DSTDIR="$2"
DSTNAME="$3"

FULLBACKUP="$DSTDIR/$DSTNAME.7z"

function DATE() {
	date "+%Y%m%d"
}

function TIME() {
	date "+%H%M%S"
}

function STRIPEXTENSION() {
	echo "$1" | sed -r 's/\...?.?.?$//'
}

if [ ! -e "$FULLBACKUP" ]; then
	# Do full backup to create a base archive
	7z a "$FULLBACKUP" "$SRCDIR"
else
	# Do differential backup to update base archive
	7z u "$FULLBACKUP" "$SRCDIR" -u- -up0q3r2x2y2z0w2!"$(STRIPEXTENSION "$FULLBACKUP") $(DATE) $(TIME).7z"
fi

echo "Press any key to continue..."
read

