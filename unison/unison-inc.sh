#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

DEBUG=0

PRFDIR=~/.unison/sync
BACKUP=".unison-backup"
LOGFILE="unison-sync.log"

function createDir() {
	ERR=0
	if [ ! -e "$1" ]; then
		mkdir -p "$1"
		ERR=$(expr $ERR + $?)
	fi
	return $ERR
}

function createDirs() {
	ERR=0
	createDir "$1"
	ERR=$(expr $ERR + $?)
	createDir "$2"
	ERR=$(expr $ERR + $?)
	return $ERR
}

function normalizeDir() {
	# rsync in particular operates differently depending on whether the source has a trailing '/';
	# this function normalizes directory names w/o the trailing '/'
	DIR=$(dirname "$1")/$(basename "$1")
	if [ $DEBUG != 0 ]; then
		echo "normalizeDir: $1 -> $DIR" > /dev/stderr
	fi
	echo "$DIR"
}

function setup() {
	if [ ! -e "$PRFDIR" ]; then
		createDir "$PRFDIR"
	fi

	if [ ! -e "$PRFDIR/common" ]; then
		cp -n $(dirname "$0")/common "$PRFDIR/"
	fi
}

function buildprf() {
	ROOT1="$1"
	ROOT2="$2"
	DIR="$3"

	PRF="$(mktemp "unison-XXXXXX").prf"

	LABEL="$ROOT1 <-> $ROOT2 - $DIR"
	echo "include sync/common" > "$PRFDIR/$PRF"
	echo "label = \"$LABEL\"" >> "$PRFDIR/$PRF"
	echo "root = $ROOT1/$DIR/" >> "$PRFDIR/$PRF"
	echo "root = $ROOT2/$DIR/" >> "$PRFDIR/$PRF"

	BACKUPDIR="$ROOT1/$DIR/$BACKUP"
	createDir "$BACKUPDIR"
	echo >> "$PRFDIR/$PRF"
	echo "backupdir = $BACKUPDIR" >> "$PRFDIR/$PRF"
	echo "backup = Name *" >> "$PRFDIR/$PRF"
	echo "logfile = $BACKUPDIR/$LOGFILE" >> "$PRFDIR/$PRF"

	echo "$PRF"
}


function buildprf2() {
	ROOT1="$1"
	ROOT2="$2"

	PRF="$(mktemp "unison-XXXXXX").prf"

	mkdir -p "$PRFDIR"
	echo "include sync/common" > "$PRFDIR/$PRF"
	echo "label = \"$ROOT1 <-> $ROOT2\"" >> "$PRFDIR/$PRF"
	echo "root = $ROOT1/" >> "$PRFDIR/$PRF"
	echo "root = $ROOT2/" >> "$PRFDIR/$PRF"

	BACKUPDIR="$ROOT1/$BACKUP"
	createDir "$BACKUPDIR"
	echo >> "$PRFDIR/$PRF"
	echo "backupdir = $BACKUPDIR" >> "$PRFDIR/$PRF"
	echo "backup = Name *" >> "$PRFDIR/$PRF"
	echo "logfile = $BACKUPDIR/$LOGFILE" >> "$PRFDIR/$PRF"

	echo "$PRF"
}

function changeFlags() {
	if [ $DEBUG != 0 ]; then
		echo "changeFlags($1)" > /dev/stderr
	fi

	ERR=0
	# Synchronization to an SMB share seems to result in files on the share getting marked as 'hidden'
	# Use this function to get rid of that flag
	chflags -R nohidden "$1"
	ERR=$(expr $ERR + $?)

	if [ $DEBUG != 0 ]; then
		echo "changeFlags($ERR)" > /dev/stderr
	fi

	return $ERR
}

function execUnison() {
	SRC="$1"
	DST="$2"
	DIR="$3"

	echo "--- $SRC <-> $DST - $DIR ---"
	if ( createDirs "$SRC/$DIR" "$DST/$DIR" ); then
		setup
		PRF=$(buildprf "$SRC" "$DST" "$DIR")
		unison "$(basename "$PRFDIR")/$PRF"
		changeFlags "$SRC/$DIR"
		changeFlags "$DST/$DIR"
		rm "$PRFDIR/$PRF"
	fi
	echo
}

function execUnison2() {
	SRC="$1"
	DST="$2"

	echo "--- $SRC <-> $DST ---"
	setup
	PRF=$(buildprf2 "$SRC" "$DST")
	unison "$(basename "$PRFDIR")/$PRF"
	changeFlags "$SRC"
	changeFlags "$DST"
	rm "$PRFDIR/$PRF"
	echo
}

function execRsync() {
	SRCDIR="$1"
	DSTBASEDIR="$2"
	SRCSUBDIR="$3"

	ERR=0
	echo "--- $SRCDIR -> $DSTBASEDIR - $SRCSUBDIR ---"
	RESULT=$(execRsync2 "$SRCDIR/$SRCSUBDIR" "$DSTBASEDIR")
	ERR=$(expr $ERR + $?)
	echo
	return $ERR
}

function execRsync2() {
	SRCDIR=$(normalizeDir "$1")
	DSTBASEDIR=$(normalizeDir "$2")

	ERR=0
	RESULT=$(rsync -av --fileflags "$SRCDIR" "$DSTBASEDIR/")
	ERR=$(expr $ERR + $?)
	return $ERR
}

