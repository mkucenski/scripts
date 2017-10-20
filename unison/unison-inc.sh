#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

PRFDIR="$HOME/.unison/sync"
LOGDIR="$HOME/.unison/log"
LOGFILE="$LOGDIR/unison-inc.log"

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

	if [ ! -e "$LOGDIR" ]; then
		createDir "$LOGDIR"
	fi

	cp $(dirname "$0")/common "$PRFDIR/"
}

function buildprf() {
	ROOT1="$1"
	ROOT2="$2"
	DIR="$3"

	PRF="$(mktemp "$PRFDIR/unison-XXXXXX")"
	echo "include sync/common" > "$PRF"
	echo "root = $ROOT1/$DIR/" >> "$PRF"
	echo "root = $ROOT2/$DIR/" >> "$PRF"
	echo "backuploc = local" >> "$PRF"
	echo "backup = Name *" >> "$PRF"
	echo "log = true" >> "$PRF"
	echo "logfile = $LOGFILE" >> "$PRF"

	echo "$PRF"
}

function buildprf2() {
	ROOT1="$1"
	ROOT2="$2"

	PRF="$(mktemp "$PRFDIR/unison-XXXXXX")"
	echo "include sync/common" > "$PRF"
	echo "root = $ROOT1/" >> "$PRF"
	echo "root = $ROOT2/" >> "$PRF"
	echo "backuploc = local" >> "$PRF"
	echo "backup = Name *" >> "$PRF"
	echo "log = true" >> "$PRF"
	echo "logfile = $LOGFILE" >> "$PRF"

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

	if ( createDirs "$SRC/$DIR" "$DST/$DIR" ); then
		setup
		PRF=$(buildprf "$SRC" "$DST" "$DIR")
		UNILOG="$(getlogfile "$PRF")"
		BANNER="$SRC <-> $DST - $DIR"
		START "$0" "$UNILOG" "$*"

		LOG "$BANNER" "$UNILOG"
		NOTIFY "$BANNER" "$0"
		unison "$(basename "$(dirname "$PRF")")/$(basename "$PRF")"
		cat "$PRF" >> "$UNILOG"
		rm "$PRF"

		END "$0" "$UNILOG"
	fi
}

function execUnison2() {
	SRC="$1"
	DST="$2"

	setup
	PRF=$(buildprf2 "$SRC" "$DST")
	UNILOG="$(getlogfile "$PRF")"
	BANNER="$SRC <-> $DST"
	START "$0" "$UNILOG" "$*"

	LOG "$BANNER" "$UNILOG"
	NOTIFY "$BANNER" "$0"
	unison "$(basename "$(dirname "$PRF")")/$(basename "$PRF")"
	cat "$PRF" >> "$UNILOG"
	rm "$PRF"

	END "$0" "$UNILOG"
}

function execRsync() {
	SRCDIR="$1"
	DSTBASEDIR="$2"
	SRCSUBDIR="$3"

	ERR=0

	NOTIFY "$SRCDIR -> $DSTBASEDIR - $SRCSUBDIR" "$0"
	RESULT=$(execRsync2 "$SRCDIR/$SRCSUBDIR" "$DSTBASEDIR")
	ERR=$(expr $ERR + $?)

	return $ERR
}

function execRsync2() {
	SRCDIR=$(normalizeDir "$1")
	DSTBASEDIR=$(normalizeDir "$2")

	ERR=0

	# RESULT=$(rsync -av --fileflags "$SRCDIR" "$DSTBASEDIR/")
	RESULT=$(rsync -av "$SRCDIR" "$DSTBASEDIR/")
	ERR=$(expr $ERR + $?)

	return $ERR
}

