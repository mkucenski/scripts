#!bin/bash
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
	# this function normalizes directory names to not include the trailing '/'
	DIR="$(dirname "$1")/$(basename "$1")"
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
	SUBDIR="$3"

	if [ -n "$SUBDIR" ]; then
		ROOT1="$SRC/$SUBDIR"
		ROOT2="$DST/$SUBDIR"
	else
		ROOT1="$SRC"
		ROOT2="$DST"
	fi

	if ( createDirs "$ROOT1" "$ROOT2" ); then
		setup
		PRF="$(buildprf "$ROOT1" "$ROOT2")"
		UNILOG="$(getlogfile "$PRF")"
		START "$0" "$UNILOG" "$*"
		LOG_VERSION "unison" "$(unison -version)" "$UNILOG"

		LOG "$ROOT1 <-> $ROOT2" "$UNILOG"
		unison "$(basename "$(dirname "$PRF")")/$(basename "$PRF")"
		cat "$PRF" >> "$UNILOG"
		rm "$PRF"

		END "$0" "$UNILOG"
	fi
}

function execRsync() {
	SRCDIR="$1"
	DSTBASEDIR="$2"
	SRCSUBDIR="$3"

	if [ -n "$SRCSUBDIR" ]; then
		SRCDIR="$SRCDIR/$SRCSUBDIR"
	fi

	ERR=0

	# rsync -av --fileflags "$SRCDIR" "$DSTBASEDIR/"
	rsync -av "$(normalizeDir "$SRCDIR")" "$(normalizeDir "$DSTBASEDIR")/"
	ERR=$(expr $ERR + $?)

	return $ERR
}

