#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh
# DEBUG "Included: unison-sync-inc.sh" "$0"

DEBUG=0

PRF=sync/$(basename $(mktemp -t $(basename "$0"))).prf
PRFDIR=~/.unison

function buildprf() {
	ROOT1="$1"
	ROOT2="$2"
	DIR="$3"
	BACKUPDIR="$4"

	echo "include sync/common" > "$PRFDIR/$PRF"
	echo "label = \"$ROOT1 <-> $ROOT2 - $DIR\"" >> "$PRFDIR/$PRF"
	echo "root = $ROOT1/$DIR/" >> "$PRFDIR/$PRF"
	echo "root = $ROOT2/$DIR/" >> "$PRFDIR/$PRF"

	echo "" >> "$PRFDIR/$PRF"
	echo "backupdir = $BACKUPDIR" >> "$PRFDIR/$PRF"
	echo "backup = Name *" >> "$PRFDIR/$PRF"

	echo "" >> "$PRFDIR/$PRF"
	echo "logfile = $BACKUPDIR/unison-sync.log" >> "$PRFDIR/$PRF"
}


function buildprf2() {
	ROOT1="$1"
	ROOT2="$2"

	echo "include sync/common" > "$PRFDIR/$PRF"
	echo "label = \"$ROOT1 <-> $ROOT2\"" >> "$PRFDIR/$PRF"
	echo "root = $ROOT1/" >> "$PRFDIR/$PRF"
	echo "root = $ROOT2/" >> "$PRFDIR/$PRF"
}

function createDirs() {
	if [ $DEBUG != 0 ]; then
		echo "createDirs($1)" > /dev/stderr
	fi

	ERR=0
	if [ ! -e "$1" ]; then
		mkdir -p "$1"
		ERR=$(expr $ERR + $?)
	fi
	if [ ! -e "$2" ]; then
		mkdir -p "$2"
		ERR=$(expr $ERR + $?)
	fi

	if [ $DEBUG != 0 ]; then
		echo "createDirs($ERR)" > /dev/stderr
	fi

	return $ERR
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
	echo ""
	echo "--- $1 <-> $2 - $3 ---"
	if ( createDirs "$1/$3" "$2/$3" ); then
		buildprf "$1" "$2" "$3" "$4"
		unison $PRF
		changeFlags "$1/$3"
		changeFlags "$2/$3"
	fi
}

function execUnison2() {
	echo ""
	echo "--- $1 <-> $2 ---"
	buildprf2 "$1" "$2" "$3"
	unison $PRF
	#changeFlags "$1"
	#changeFlags "$2"
}

function execRsync() {
	SRCDIR="$1"
	DSTBASEDIR="$2"
	SRCSUBDIR="$3"

	ERR=0
	echo ""
	echo "--- $SRCDIR -> $DSTBASEDIR - $SRCSUBDIR ---"
	if ( createDirs "$SRCDIR/$SRCSUBDIR" "$DSTBASEDIR/$SRCSUBDIR" ); then
		RESULT=$(execRsync2 "$SRCDIR/$SRCSUBDIR" "$DSTBASEDIR")
		ERR=$(expr $ERR + $?)
		if [ $DEBUG != 0 ]; then
			echo "execRsync: $RESULT ($ERR)" > /dev/stderr
		fi
		echo ""
	else
		ERR=$(expr $ERR + $?)
		if [ $DEBUG != 0 ]; then
			echo "execRsync: $ERR" > /dev/stderr
		fi
	fi	
	return $ERR
}

function execRsync2() {
	SRCDIR=$(normalizeDir "$1")
	DSTBASEDIR=$(normalizeDir "$2")

	ERR=0
	RESULT=$(rsync -av --fileflags "$SRCDIR" "$DSTBASEDIR/")
	ERR=$(expr $ERR + $?)
	if [ $DEBUG != 0 ]; then
		echo "execRsync2: $RESULT ($ERR)" > /dev/stderr
	fi
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

