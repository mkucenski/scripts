#!/bin/bash
ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

COMMON_SUCCESS=0
COMMON_ERROR=1
COMMON_UNKNOWN=255

function DEBUG() {
	if [ $ENABLE_DEBUG -gt 0 ]; then
		_COMMON_DEBUG_MSG="$1"
		_COMMON_DEBUG_SRC="$2"
		_COMMON_DEBUG_LOG="$3"
		_COMMON_DEBUG_OUTPUT="DEBUG($(basename "$_COMMON_DEBUG_SRC")): $_COMMON_DEBUG_MSG"
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

function USAGE_EXAMPLE() {
	if [ $# -eq 1 ]; then
		echo "Example: $1" > /dev/stderr
		echo > /dev/stderr
	fi
}

# On systems where gsed/gawk exist, we assume that is the correct GNU version to use.
SEDCMD=$(if [ -n "$(which gsed)" ]; then echo "gsed"; else echo "sed"; fi)
AWKCMD=$(if [ -n "$(which gawk)" ]; then echo "gawk"; else echo "awk"; fi)

function FULL_PATH() {
	# Return the full/absolute path for a file
	FILE="$1"
	echo "$(cd $(dirname "$FILE"); pwd)/$(basename "$FILE")"
}

function LOG_SCRIPT_BASE64() {
	# Base64 encode text file (or script) to retain in log files
	_COMMON_LOG_SCRIPT_BASE64_FILE="$1"
	_COMMON_LOG_SCRIPT_BASE64_LOG="$2"
	if [ -e "$_COMMON_LOG_SCRIPT_BASE64_FILE" ]; then
		_COMMON_LOG_SCRIPT_BASE64="$(base64 "$_COMMON_LOG_SCRIPT_BASE64_FILE")"
		LOG "BASE64($(basename "$_COMMON_LOG_SCRIPT_BASE64_FILE")): $_COMMON_LOG_SCRIPT_BASE64" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
	else
		ERROR "File does not exist!" "$0" "$_COMMON_LOG_SCRIPT_BASE64_LOG"
	fi
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
	_COMMON_ERROR_SRC="$2"
	_COMMON_ERROR_LOG="$3"
	_COMMON_ERROR_OUTPUT="ERROR($(basename "$_COMMON_ERROR_SRC")): $_COMMON_ERROR_MSG"
	echo "$_COMMON_ERROR_OUTPUT" > /dev/stderr
	if [ -n "$_COMMON_ERROR_LOG" ]; then
		LOG "$_COMMON_ERROR_OUTPUT" "$_COMMON_ERROR_LOG"
	fi
}

function WARNING() {
	# Output clear WARNING message to stderr and LOG (if specified)

	_COMMON_WARNING_MSG="$1"
	_COMMON_WARNING_SRC="$2"
	_COMMON_WARNING_LOG="$3"
	_COMMON_WARNING_OUTPUT="WARNING($(basename "$_COMMON_WARNING_SRC")): $_COMMON_WARNING_MSG"
	echo "$_COMMON_WARNING_OUTPUT" > /dev/stderr
	if [ -n "$_COMMON_WARNING_LOG" ]; then
		LOG "$_COMMON_WARNING_OUTPUT" "$_COMMON_WARNING_LOG"
	fi
}

function START() {
	_COMMON_START_SRC="$1"
	_COMMON_START_LOG="$2"
	_COMMON_START_OUTPUT="START($(basename "$_COMMON_START_SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$_COMMON_START_OUTPUT" "$_COMMON_START_LOG"
	LOG_SCRIPT_BASE64 "$_COMMON_START_SRC" "$_COMMON_START_LOG"
}

function END() {
	_COMMON_END_SRC="$1"
	_COMMON_END_LOG="$2"
	_COMMON_END_OUTPUT="END($(basename "$_COMMON_END_SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$_COMMON_END_OUTPUT" "$_COMMON_END_LOG"
	LOG "" "$_COMMON_END_LOG"
}

function DATETIME() {
	date "+%Y%m%d %H:%M:%S"
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
	for X in $@; do
		echo -n "<$X> "
	done
}

