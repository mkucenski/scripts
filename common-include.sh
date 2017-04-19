#!/bin/bash

# On systems where gsed/gawk exist, we assume that is the correct GNU version to use.
SEDCMD=$(if [ -n "$(which gsed)" ]; then echo "gsed"; else echo "sed"; fi)
AWKCMD=$(if [ -n "$(which gawk)" ]; then echo "gawk"; else echo "awk"; fi)

function ERROR() {
	MSG="$1"
	SRC="$2"
	LOG="$3"
	OUTPUT="ERROR($(basename "$SRC")):  $MSG"
	if [ -n "$LOG" ]; then
		echo "$OUTPUT" | tee -a "$LOG" > /dev/stderr
	else
		echo "$OUTPUT" > /dev/stderr
	fi
}

function WARNING() {
	MSG="$1"
	SRC="$2"
	LOG="$3"
	OUTPUT="WARNING($(basename "$SRC")): $MSG"
	if [ -n "$LOG" ]; then
		echo "$OUTPUT" | tee -a "$LOG" > /dev/stderr
	else
		echo "$OUTPUT" > /dev/stderr
	fi
}

function DEBUG() {
	MSG="$1"
	SRC="$2"
	OUTPUT="DEBUG($(basename "$SRC")): $MSG"
	echo "$OUTPUT" > /dev/stderr
}

function START() {
	SRC="$1"
	LOG="$2"
	OUTPUT="START($(basename "$SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$OUTPUT" "$LOG"
}

function END() {
	SRC="$1"
	LOG="$2"
	OUTPUT="END($(basename "$SRC")): $(date "+%Y%m%d %H:%M:%S")"
	LOG "$OUTPUT" "$LOG"
	LOG "" "$LOG"
}

function LOG() {
	MSG="$1"
	LOG="$2"
	if [ -n "$MSG" ]; then
		if [ -n "$LOG" ]; then
			echo "$MSG" | tee -a "$LOG"
		else
			echo "$MSG"
		fi
	else
		if [ -n "$LOG" ]; then
			echo | tee -a "$LOG"
		else
			echo
		fi
	fi
}

