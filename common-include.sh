#!/bin/bash

function DEBUG() {
	MSG="$1"
	SRC="$2"
	OUTPUT="DEBUG($(basename "$SRC")): $MSG"
	echo "$OUTPUT" > /dev/stderr
}

# DEBUG "Included: common-include.sh" "$0"

function USAGE() {
	if [ $# -ne 0 ]; then
		echo -n "Usage: $0 "
		for VAR in "$@"; do
			echo -n "<$VAR> "
		done
		echo; echo
	fi
}

# On systems where gsed/gawk exist, we assume that is the correct GNU version to use.
SEDCMD=$(if [ -n "$(which gsed)" ]; then echo "gsed"; else echo "sed"; fi)
AWKCMD=$(if [ -n "$(which gawk)" ]; then echo "gawk"; else echo "awk"; fi)

function INFO() {
	MSG="$1"
	LOGFILE="$2"
	if [ -n "$LOGFILE" ]; then
		echo "$MSG" | tee -a "$LOGFILE" > /dev/stderr
	else
		echo "$MSG" > /dev/stderr
	fi
}

function ERROR() {
	MSG="$1"
	SRC="$2"
	LOGFILE="$3"
	OUTPUT="ERROR($(basename "$SRC")):  $MSG"
	if [ -n "$LOGFILE" ]; then
		echo "$OUTPUT" | tee -a "$LOGFILE" > /dev/stderr
	else
		echo "$OUTPUT" > /dev/stderr
	fi
}

function WARNING() {
	MSG="$1"
	SRC="$2"
	LOGFILE="$3"
	OUTPUT="WARNING($(basename "$SRC")): $MSG"
	if [ -n "$LOGFILE" ]; then
		echo "$OUTPUT" | tee -a "$LOGFILE" > /dev/stderr
	else
		echo "$OUTPUT" > /dev/stderr
	fi
}

function START() {
	SRC="$1"
	LOGFILE="$2"
	OUTPUT="START($(basename "$SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$OUTPUT" "$LOGFILE"
}

function END() {
	SRC="$1"
	LOGFILE="$2"
	OUTPUT="END($(basename "$SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$OUTPUT" "$LOGFILE"
	LOG "" "$LOGFILE"
}

function LOG() {
	MSG="$1"
	LOGFILE="$2"
	if [ -n "$MSG" ]; then
		if [ -n "$LOGFILE" ]; then
			echo "$MSG" | tee -a "$LOGFILE"
		else
			echo "$MSG"
		fi
	else
		if [ -n "$LOGFILE" ]; then
			echo | tee -a "$LOGFILE"
		else
			echo
		fi
	fi
}

