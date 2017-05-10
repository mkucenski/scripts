#!/bin/bash

function DEBUG() {
	_COMMON_DEBUG_MSG="$1"
	_COMMON_DEBUG_SRC="$2"
	_COMMON_DEBUG_OUTPUT="DEBUG($(basename "$_COMMON_DEBUG_SRC")): $_COMMON_DEBUG_MSG"
	echo "$_COMMON_DEBUG_OUTPUT" > /dev/stderr
}

# DEBUG "Included: common-include.sh" "$0"

function USAGE() {
	if [ $# -ne 0 ]; then
		echo -n "Usage: $0 " > /dev/stderr
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

function INFO() {
	# Output message to stdout and LOGFILE (if specified)

	_COMMON_INFO_MSG="$1"
	_COMMON_INFO_LOGFILE="$2"
	echo "$_COMMON_INFO_MSG"
	if [ -n "$_COMMON_INFO_LOGFILE" ]; then
		LOG "$_COMMON_INFO_MSG" "$_COMMON_INFO_LOGFILE"
	fi
}

function ERROR() {
	# Output clear ERROR message to stderr and LOGFILE (if specified)

	_COMMON_ERROR_MSG="$1"
	_COMMON_ERROR_SRC="$2"
	_COMMON_ERROR_LOGFILE="$3"
	_COMMON_ERROR_OUTPUT="ERROR($(basename "$_COMMON_ERROR_SRC")): $_COMMON_ERROR_MSG"
	echo "$_COMMON_ERROR_OUTPUT" > /dev/stderr
	if [ -n "$_COMMON_ERROR_LOGFILE" ]; then
		LOG "$_COMMON_ERROR_OUTPUT" "$_COMMON_ERROR_LOGFILE"
	fi
}

function WARNING() {
	# Output clear WARNING message to stderr and LOGFILE (if specified)

	_COMMON_WARNING_MSG="$1"
	_COMMON_WARNING_SRC="$2"
	_COMMON_WARNING_LOGFILE="$3"
	_COMMON_WARNING_OUTPUT="WARNING($(basename "$_COMMON_WARNING_SRC")): $_COMMON_WARNING_MSG"
	echo "$_COMMON_WARNING_OUTPUT" > /dev/stderr
	if [ -n "$_COMMON_WARNING_LOGFILE" ]; then
		LOG "$_COMMON_WARNING_OUTPUT" "$_COMMON_WARNING_LOGFILE"
	fi
}

function START() {
	_COMMON_START_SRC="$1"
	_COMMON_START_LOGFILE="$2"
	_COMMON_START_OUTPUT="START($(basename "$_COMMON_START_SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$_COMMON_START_OUTPUT" "$_COMMON_START_LOGFILE"
}

function END() {
	_COMMON_END_SRC="$1"
	_COMMON_END_LOGFILE="$2"
	_COMMON_END_OUTPUT="END($(basename "$_COMMON_END_SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$_COMMON_END_OUTPUT" "$_COMMON_END_LOGFILE"
	LOG "" "$_COMMON_END_LOGFILE"
}

function LOG() {
	# Output message to LOGFILE (no output to stdout/stderr)

	_COMMON_LOG_MSG="$1"
	_COMMON_LOG_LOGFILE="$2"
	if [ -n "$_COMMON_LOG_LOGFILE" ]; then
		echo "$_COMMON_LOG_MSG" >> "$_COMMON_LOG_LOGFILE"
	else
		echo "$_COMMON_LOG_MSG"
	fi
}

