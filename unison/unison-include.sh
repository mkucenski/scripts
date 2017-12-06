#!bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

_UNISON_PRFDIR="$HOME/.unison/sync"
_UNISON_LOGDIR="$HOME/.unison/log"
_UNISON_LOGFILE="$_UNISON_LOGDIR/unison-inc.log"

function createDir() {
	if [ ! -e "$1" ]; then
		mkdir -p "$1"
	fi
	return $?
}

function createDirs() {
	ERR1=$(createDir "$1")
	ERR2=$(createDir "$2")
	return $((ERR1 + ERR2))
}

function setup() {
	if [ ! -e "$_UNISON_PRFDIR" ]; then
		createDir "$_UNISON_PRFDIR"
	fi

	if [ ! -e "$_UNISON_LOGDIR" ]; then
		createDir "$_UNISON_LOGDIR"
	fi

	cp "$(dirname "$0")/common" "$_UNISON_PRFDIR/"
}

function buildprf() {
	_UNISON_ROOT1="$1"
	_UNISON_ROOT2="$2"

	_UNISON_PRF="$(mktemp "$_UNISON_PRFDIR/unison-XXXXXX")"

	echo "include sync/common" > "$_UNISON_PRF"
	{
		echo "root = $_UNISON_ROOT1/"
		echo "root = $_UNISON_ROOT2/"
		echo "backuploc = local"
		echo "backup = Name *"
		echo "log = true"
		echo "logfile = $_UNISON_LOGFILE"
	} >> "$_UNISON_PRF"

	echo "$_UNISON_PRF"
}

function getlogfile() {
	_UNISON_PRF="$1"
	_UNISON_LOG="$(grep "logfile = " "$_UNISON_PRF" | $SEDCMD -r 's/logfile = (.*)/\1/')"
	echo "$_UNISON_LOG"
}

function changeFlags() {
	INFO "changeFlags($1)"

	# Synchronization to an SMB share seems to result in files on the share getting marked as 'hidden'
	# Use this function to get rid of that flag
	chflags -R nohidden "$1"
}

function execUnison() {
	_UNISON_SRC="$1"
	_UNISON_DST="$2"
	_UNISON_SUBDIR="$3"

	if [ -n "$_UNISON_SUBDIR" ]; then
		_UNISON_ROOT1="$_UNISON_SRC/$_UNISON_SUBDIR"
		_UNISON_ROOT2="$_UNISON_DST/$_UNISON_SUBDIR"
	else
		_UNISON_ROOT1="$_UNISON_SRC"
		_UNISON_ROOT2="$_UNISON_DST"
	fi

	if ( createDirs "$_UNISON_ROOT1" "$_UNISON_ROOT2" ); then
		setup
		_UNISON_PRF="$(buildprf "$_UNISON_ROOT1" "$_UNISON_ROOT2")"
		_UNISON_LOG="$(getlogfile "$_UNISON_PRF")"
		START "$0" "$_UNISON_LOG" "$*"
		INFO "--- $_UNISON_ROOT1 <-> $_UNISON_ROOT2 ---" "$_UNISON_LOG"
		LOG_VERSION "unison" "$(unison -version)" "$_UNISON_LOG"

		LOG "$_UNISON_ROOT1 <-> $_UNISON_ROOT2" "$_UNISON_LOG"
		unison "$(basename "$(dirname "$_UNISON_PRF")")/$(basename "$_UNISON_PRF")"
		cat "$_UNISON_PRF" >> "$_UNISON_LOG"
		rm "$_UNISON_PRF"

		END "$0" "$_UNISON_LOG"
	fi
}

function execRsync() {
	_UNISON_SRCDIR="$1"
	_UNISON_DSTBASEDIR="$2"
	_UNISON_SRCSUBDIR="$3"

	if [ -n "$_UNISON_SRCSUBDIR" ]; then
		_UNISON_SRCDIR="$_UNISON_SRCDIR/$_UNISON_SRCSUBDIR"
	fi

	# rsync -av --fileflags "$_UNISON_SRCDIR" "$_UNISON_DSTBASEDIR/"
	rsync -av "$(NORMALIZEDIR "$_UNISON_SRCDIR")" "$(NORMALIZEDIR "$_UNISON_DSTBASEDIR")/"
}

