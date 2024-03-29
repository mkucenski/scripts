#!/usr/bin/env bash
ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

function NOTIFY() {
	_COMMON_NOTIFY_MSG="$1"
	_COMMON_NOTIFY_SRC="$(basename "$2")"
	_COMMON_NOTIFY_OS="$(uname)"
	if [ "$_COMMON_NOTIFY_OS" = "Darwin" ]; then
		INFO "$_COMMON_NOTIFY_SRC: $_COMMON_NOTIFY_MSG"
		"${BASH_SOURCE%/*}/macOS/notification.sh" "$(DATETIME): $_COMMON_NOTIFY_MSG" "$_COMMON_NOTIFY_SRC" ""
	else
		INFO "$_COMMON_NOTIFY_SRC: $_COMMON_NOTIFY_MSG"
	fi
}

function DEBUG() {
	if [ $ENABLE_DEBUG -gt 0 ]; then
		_COMMON_DEBUG_MSG="$1"
		_COMMON_DEBUG_SRC="$(basename "$2")"
		_COMMON_DEBUG_LOG="$3"
		_COMMON_DEBUG_OUTPUT="DEBUG($_COMMON_DEBUG_SRC): $_COMMON_DEBUG_MSG"
		echo "$_COMMON_DEBUG_OUTPUT" > /dev/stderr
		if [ -n "$_COMMON_DEBUG_LOG" ]; then
			LOG "$_COMMON_DEBUG_OUTPUT" "$_COMMON_DEBUG_LOG"
		fi
	fi
}

function USAGE() {
	if [ $# -ne 0 ]; then
		echo -n "Usage: $(basename "$0") " > /dev/stderr
		for _COMMON_USAGE_VAR in "$@"; do
			echo -n "<$_COMMON_USAGE_VAR> " > /dev/stderr
		done
		echo > /dev/stderr; echo > /dev/stderr
	fi
}

function USAGE_DESCRIPTION() {
	if [ $# -eq 1 ]; then
		echo "Description: $1" > /dev/stderr
		echo > /dev/stderr
	fi
}

function USAGE_EXAMPLE() {
	if [ $# -eq 1 ]; then
		echo "Example: $1" > /dev/stderr
		echo > /dev/stderr
	fi
}

# On systems where gsed/gawk exist, we assume that is the correct GNU version to use.
SEDCMD=$(if [ -n "$(which gsed 2>/dev/null)" ]; then echo "gsed"; else echo "sed"; fi); export SEDCMD
AWKCMD=$(if [ -n "$(which gawk 2>/dev/null)" ]; then echo "gawk"; else echo "awk"; fi); export AWKCMD

function SUDO_USER() {
	who am i | $SEDCMD -r 's/([^[:space:]]+).*/\1/'
}

function FULL_PATH() {
	# Return the full/absolute path
	echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

function EXEC_CMD() {
	# Evaluate/execute the command given by a string; log the command as well as send to stderr
	INFO_ERR "CMD: $1" "$2"
	# Redirect stdout/stderr to the logfile, but still report back to the console on stdout/stderr
	eval "$1" > >(tee -a "$2") 2> >(tee -a "$2" >&2)
}

function LOG_VERSION() {
	# LOG an executable name (e.g. dig) and it's version string into the given log file for future reference.

	_COMMON_LOG_VERSION_CMD="$1"
	_COMMON_LOG_VERSION_STRING="$2"
	_COMMON_LOG_VERSION_LOG="$3"

	LOG "VERSION($_COMMON_LOG_VERSION_CMD): $_COMMON_LOG_VERSION_STRING" "$_COMMON_LOG_VERSION_LOG"
}

function LOG_SCRIPT_BASE64() {
	# Base64 encode text file (or script) to retain in log files
	_COMMON_LOG_SCRIPT_BASE64_FILE="$1"
	_COMMON_LOG_SCRIPT_BASE64_LOG="$2"
	if [ -e "$_COMMON_LOG_SCRIPT_BASE64_FILE" ]; then
		_COMMON_LOG_SCRIPT_BASE64="$(BASE64_GZ_FILE "$_COMMON_LOG_SCRIPT_BASE64_FILE")"
		LOG "BASE64_GZ($(basename "$_COMMON_LOG_SCRIPT_BASE64_FILE")):" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
		LOG "$_COMMON_LOG_SCRIPT_BASE64" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
	else
		ERROR "File does not exist!" "$0" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
	fi
}

function ROT13() {
	# Decode/encode the passed string
	echo "$1" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

function BASE64_GZ_STRING() {
	echo "$1" | gzip -c | base64
}

function BASE64_GZ_FILE() {
	gzip -c "$1" | base64
}

function MKTEMP() {
	mktemp "${TMPDIR:-/tmp/}$(basename "$1").XXXXXX"
}

function MKTEMPDIR() {
	mktemp -d "${TMPDIR:-/tmp/}$(basename "$1").XXXXXX"
}

function MKTEMPLOCAL() {
	mktemp "$1.XXXXXX"
}	

function STRIP_EXTENSION() {
	_COMMON_FILENAME="$1"
	echo "${_COMMON_FILENAME%.*}"
}

function GET_EXTENSION() {
	_COMMON_FILENAME="$1"
	echo "${_COMMON_FILENAME##*.}"
}

function CHECK_ROOT() {
	USER=$(whoami)
	if [ "$USER" = root ]; then
		echo "true"
	else
		echo "false"
	fi
}

function INFO_ERR() {
	# Output message to stderr and LOG (if specified)

	_COMMON_INFO_MSG="$1"
	_COMMON_INFO_LOG="$2"
	echo "$_COMMON_INFO_MSG" > /dev/stderr
	if [ -n "$_COMMON_INFO_LOG" ]; then
		LOG "$_COMMON_INFO_MSG" "$_COMMON_INFO_LOG"
	fi
}

function INFO() {
	# Output message to stdout and LOG (if specified)

	_COMMON_INFO_MSG="$1"
	_COMMON_INFO_LOG="$2"
	echo "$_COMMON_INFO_MSG"
	if [ -n "$_COMMON_INFO_LOG" ]; then
		LOG "$_COMMON_INFO_MSG" "$_COMMON_INFO_LOG"
	fi
}

function ERROR() {
	# Output clear ERROR message to stderr and LOG (if specified)

	_COMMON_ERROR_MSG="$1"
	_COMMON_ERROR_SRC="$(basename "$2")"
	_COMMON_ERROR_LOG="$3"
	_COMMON_ERROR_OUTPUT="ERROR($_COMMON_ERROR_SRC): $_COMMON_ERROR_MSG"
	echo "$_COMMON_ERROR_OUTPUT" > /dev/stderr
	if [ -n "$_COMMON_ERROR_LOG" ]; then
		LOG "$_COMMON_ERROR_OUTPUT" "$_COMMON_ERROR_LOG"
	fi
}

function WARNING() {
	# Output clear WARNING message to stderr and LOG (if specified)

	_COMMON_WARNING_MSG="$1"
	_COMMON_WARNING_SRC="$(basename "$2")"
	_COMMON_WARNING_LOG="$3"
	_COMMON_WARNING_OUTPUT="WARNING($_COMMON_WARNING_SRC): $_COMMON_WARNING_MSG"
	echo "$_COMMON_WARNING_OUTPUT" > /dev/stderr
	if [ -n "$_COMMON_WARNING_LOG" ]; then
		LOG "$_COMMON_WARNING_OUTPUT" "$_COMMON_WARNING_LOG"
	fi
}

function START() {
	_COMMON_START_SRC="$1"
	_COMMON_START_LOG="$2"
	_COMMON_START_ARGS="$(echo "$3" | tr "\n" ";")"
	LOG "START($(basename "$_COMMON_START_SRC")): $(DATETIME)" "$_COMMON_START_LOG"
	LOG "PWD: $(pwd)" "$_COMMON_START_LOG"
	if [ -n "$_COMMON_START_ARGS" ]; then
		LOG "ARGS: '$_COMMON_START_ARGS'" "$_COMMON_START_LOG"
	fi
	LOG "HOST: $(uname -a)" "$_COMMON_START_LOG"
}

function END() {
	_COMMON_END_SRC="$1"
	_COMMON_END_LOG="$2"
	LOG_SCRIPT_BASE64 "$_COMMON_END_SRC" "$_COMMON_END_LOG"
	LOG "END($(basename "$_COMMON_END_SRC")): $(DATETIME)" "$_COMMON_END_LOG"
	LOG "" "$_COMMON_END_LOG"
}

function DATETIME() {
	date "+%Y%m%d %H:%M:%S"
}

function DATE() {
	date "+%Y%m%d"
}

function TIME() {
	date "+%H%M%S"
}

function LOG() {
	# Output message to LOG (no output to stdout/stderr)

	_COMMON_LOG_MSG="$1"
	_COMMON_LOG_LOG="$2"
	if [ -n "$_COMMON_LOG_LOG" ]; then
		echo "$_COMMON_LOG_MSG" >> "$_COMMON_LOG_LOG"
	fi
}

function ECHO_ARGS() {
	for X in "$@"; do
		echo -n "<$X> "
	done
}

function LOCK {
	# Store PID in a lockfile to prevent concurrent execution;
	# lockfile can be any arbitrary location based on how 
	# restrictive you want to be. Pass "$0" to prevent 
	# concurrent execution of the script in all cases.

	_COMMON_LOCK="$1"
	_COMMON_LOCK_LOG="$2"

	# Append ".pid" to any lock request that doesn't already
	# have it. Allows you to pass "$0" as the lock.
	EXT="$(GET_EXTENSION "$_COMMON_LOCK")"
	if [ "$EXT" != "pid" ]; then
		_COMMON_LOCK="$_COMMON_LOCK.pid"
	fi

	if [ -f "$_COMMON_LOCK" ]; then
		PID=$(cat "$_COMMON_LOCK")
		if kill -0 "$PID" > /dev/null 2>&1; then
			WARNING "Active lock; script already running!" "$_COMMON_LOCK" "$_COMMON_LOCK_LOG"
			exit 1
		else
			WARNING "Stale lock; removing lockfile." "$_COMMON_LOCK" "$_COMMON_LOCK_LOG"
		fi
	fi

	echo $$ > "$_COMMON_LOCK"
}

function UNLOCK {
	_COMMON_LOCK="$1"
	_COMMON_LOCK_LOG="$2"

	EXT="$(GET_EXTENSION "$_COMMON_LOCK")"
	if [ "$EXT" != "pid" ]; then
		_COMMON_LOCK="$_COMMON_LOCK.pid"
	fi

	rm -f "$_COMMON_LOCK"
}

function HOSTNAME {
	hostname | "$SEDCMD" -r 's/\.local//'
}

function MD5HASH_STRING() {
	echo "$1" | openssl md5 -r | cut -d " " -f 1 | tr "[:lower:]" "[:upper:]"
}

function MD5HASH_FILE() {
	openssl md5 -r "$1" | cut -d " " -f 1 | tr "[:lower:]" "[:upper:]"
}
	
