#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

PRFDIR="$HOME/.unison/sync"
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

	PRF="$(mktemp "$PRFDIR/unison-XXXXXX")"
	LABEL="$ROOT1 <-> $ROOT2 - $DIR"
	echo "include sync/common" > "$PRF"
	echo "label = \"$LABEL\"" >> "$PRF"
	echo "root = $ROOT1/$DIR/" >> "$PRF"
	echo "root = $ROOT2/$DIR/" >> "$PRF"

	BACKUPDIR="$ROOT1/$DIR/$BACKUP"
	createDir "$BACKUPDIR"
	echo >> "$PRF"
	echo "backupdir = $BACKUPDIR" >> "$PRF"
	echo "backup = Name *" >> "$PRF"
	echo "logfile = $BACKUPDIR/$LOGFILE" >> "$PRF"

	echo "$PRF"
}


function buildprf2() {
	ROOT1="$1"
	ROOT2="$2"

	PRF="$(mktemp "$PRFDIR/unison-XXXXXX")"

	echo "include sync/common" > "$PRF"
	echo "label = \"$ROOT1 <-> $ROOT2\"" >> "$PRF"
	echo "root = $ROOT1/" >> "$PRF"
	echo "root = $ROOT2/" >> "$PRF"

	BACKUPDIR="$ROOT1/$BACKUP"
	createDir "$BACKUPDIR"
	echo >> "$PRF"
	echo "backupdir = $BACKUPDIR" >> "$PRF"
	echo "backup = Name *" >> "$PRF"
	echo "logfile = $BACKUPDIR/$LOGFILE" >> "$PRF"

	echo "$PRF"
}

function getlogfile() {
	PRF="$1"
	UNILOG="$(grep "logfile = " "$PRF" | $SEDCMD -r 's/logfile = (.*)/\1/')"
	echo "$UNILOG"
}

function changeFlags() {
	INFO "changeFlags($1)"

	ERR=0
	# Synchronization to an SMB share seems to result in files on the share getting marked as 'hidden'
	# Use this function to get rid of that flag
	chflags -R nohidden "$1"
	ERR=$(expr $ERR + $?)

	return $ERR
}

function execUnison() {
	SRC="$1"
	DST="$2"
	DIR="$3"

	BANNER="--- $SRC <-> $DST - $DIR ---"
	INFO "$BANNER"
	if ( createDirs "$SRC/$DIR" "$DST/$DIR" ); then
		setup
		PRF=$(buildprf "$SRC" "$DST" "$DIR")
		UNILOG="$(getlogfile "$PRF")"
		START "$0" "$UNILOG"
		LOG "$BANNER" "$UNILOG"
		PRFBASE="$(basename "$(dirname "$PRF")")/$(basename "$PRF")"
		unison "$PRFBASE"
		# changeFlags "$SRC/$DIR"
		# changeFlags "$DST/$DIR"
		rm "$PRF"
		END "$0" "$UNILOG"
	fi
	INFO
}

function execUnison2() {
	SRC="$1"
	DST="$2"

	BANNER="--- $SRC <-> $DST ---"
	INFO "$BANNER"
	setup
	PRF=$(buildprf2 "$SRC" "$DST")
	UNILOG="$(getlogfile "$PRF")"
	START "$0" "$UNILOG"
	LOG "$BANNER" "$UNILOG"
	PRFBASE="$(basename "$(dirname "$PRF")")/$(basename "$PRF")"
	unison "$PRFBASE"
	# changeFlags "$SRC"
	# changeFlags "$DST"
	rm "$PRF"
	END "$0" "$UNILOG"
	INFO
}

function execRsync() {
	SRCDIR="$1"
	DSTBASEDIR="$2"
	SRCSUBDIR="$3"

	ERR=0
	INFO "--- $SRCDIR -> $DSTBASEDIR - $SRCSUBDIR ---"
	RESULT=$(execRsync2 "$SRCDIR/$SRCSUBDIR" "$DSTBASEDIR")
	ERR=$(expr $ERR + $?)
	INFO	
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
