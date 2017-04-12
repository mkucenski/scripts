#!/bin/bash

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

