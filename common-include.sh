#!/bin/bash
ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

export COMMON_SUCCESS=0
export COMMON_ERROR=1
export COMMON_UNKNOWN=255

function NORMALIZEDIR() {
	# rsync in particular operates differently depending on whether the source has a trailing '/';
	# this function normalizes directory names to not include the trailing '/'
	DIR="$(dirname "$1")/$(basename "$1")"
	echo "$DIR"
}

function NOTIFY() {
	_COMMON_NOTIFY_MSG="$1"
	_COMMON_NOTIFY_SRC="$(basename "$2")"
	_COMMON_NOTIFY_OS="$(uname)"
	if [ "$_COMMON_NOTIFY_OS" = "Darwin" ]; then
		INFO "$_COMMON_NOTIFY_SRC: $_COMMON_NOTIFY_MSG"
		"${BASH_SOURCE%/*}/macOS/notification.sh" "$_COMMON_NOTIFY_MSG" "$_COMMON_NOTIFY_SRC" ""
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
	else
		echo "Usage information unavailable!" > /dev/stderr
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
SEDCMD=$(if [ -n "$(which gsed)" ]; then echo "gsed"; else echo "sed"; fi); export SEDCMD
AWKCMD=$(if [ -n "$(which gawk)" ]; then echo "gawk"; else echo "awk"; fi); export AWKCMD

function SUDO_USER() {
	who am i | $SEDCMD -r 's/([^[:space:]]+).*/\1/'
}

function FULL_PATH() {
	# Return the full/absolute path for a file
	FILE="$1"
	echo "$(cd "$(dirname "$FILE")"; pwd)/$(basename "$FILE")"
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
		_COMMON_LOG_SCRIPT_BASE64="$(BASE64_FILE "$_COMMON_LOG_SCRIPT_BASE64_FILE")"
		LOG "BASE64($(basename "$_COMMON_LOG_SCRIPT_BASE64_FILE")): $_COMMON_LOG_SCRIPT_BASE64" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
	else
		ERROR "File does not exist!" "$0" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
	fi
}

function BASE64_STRING() {
	echo "$1" | base64
}

function BASE64_FILE() {
	base64 "$1"
}

function MKTEMP() {
	mktemp -t "$(basename "$1")" || return $COMMON_ERROR
	return $COMMON_SUCCESS
}

function MKTEMPDIR() {
	mktemp -d -t "$(basename "$1")" || return $COMMON_ERROR
	return $COMMON_SUCCESS
}

function MKTEMPUNIQ() {
	mktemp "$1.XXXXXX" || return $COMMON_ERROR
	return $COMMON_SUCCESS
}	

function SAVE_EXTENSION() {
	_COMMON_FILENAME="$1"
	echo "$_COMMON_FILENAME" | $SEDCMD -r 's/.*\.(..?.?.?)$/\1/'
}

function STRIP_EXTENSION() {
	_COMMON_FILENAME="$1"
	echo "$_COMMON_FILENAME" | $SEDCMD -r 's/\...?.?.?$//'
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
	# Output message to stderr nd LOG (if specified)

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
	_COMMON_START_SCRIPT="$(basename "$_COMMON_START_SRC")"
	_COMMON_START_OUTPUT="START($_COMMON_START_SCRIPT): $(DATETIME)"
	LOG "$_COMMON_START_OUTPUT" "$_COMMON_START_LOG"
	if [ -n "$_COMMON_START_ARGS" ]; then
		LOG "ARGS($_COMMON_START_SCRIPT): '$_COMMON_START_ARGS'" "$_COMMON_START_LOG"
	fi
	LOG_SCRIPT_BASE64 "$_COMMON_START_SRC" "$_COMMON_START_LOG"
	LOG "HOST: $(uname -a)" "$_COMMON_START_LOG"
	LOG "" "$_COMMON_START_LOG"
}

function END() {
	_COMMON_END_SRC="$1"
	_COMMON_END_LOG="$2"
	_COMMON_END_OUTPUT="END($(basename "$_COMMON_END_SRC")): $(DATETIME)"
	LOG "$_COMMON_END_OUTPUT" "$_COMMON_END_LOG"
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
	# Store PID in a lockfile to prevent concurrent execution of the script.
	# lockfile will be SCRIPT_DIR/.$SCRIPT_NAME.pid

	_COMMON_LOCK_SRC_SCRIPT="$1"
	_COMMON_LOCK_LOG="$2"

	_COMMON_LOCK="$(dirname "$_COMMON_LOCK_SRC_SCRIPT")/.$(basename "$_COMMON_LOCK_SRC_SCRIPT").pid"

	if [ -f "$_COMMON_LOCK" ]; then
		PID=$(cat "$_COMMON_LOCK")
		if kill -0 "$PID" > /dev/null 2>&1; then
			WARNING "Active lock; script already running!" "$_COMMON_LOCK_SRC_SCRIPT" "$_COMMON_LOCK_LOG"
			exit $COMMON_ERROR
		else
			WARNING "Stale lock; removing ($_COMMON_LOCK)" "$_COMMON_LOCK_SRC_SCRIPT" "$_COMMON_LOCK_LOG"
		fi
	fi

	echo $$ > "$_COMMON_LOCK"
}

function UNLOCK {
	_COMMON_LOCK_SRC_SCRIPT="$1"
	_COMMON_LOCK_LOG="$2"

	_COMMON_LOCK="$(dirname "$_COMMON_LOCK_SRC_SCRIPT")/.$(basename "$_COMMON_LOCK_SRC_SCRIPT").pid"

   rm -f "$_COMMON_LOCK"
}
