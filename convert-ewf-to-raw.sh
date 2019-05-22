#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

EWF="$1"
RAW="$2"
if [ $# -eq 0 ]; then
	USAGE "EWF" "RAW" && exit 1
fi

DEBUG=0
LOG="$RAW.log"

if [ ! -e "$RAW" ]; then
	EWFINFO=$(ewfinfo "$EWF" | tee -a "$LOG")

	BYTES=$(echo "$EWFINFO" | grep "Media size:" | $SEDCMD -r 's/^[[:space:]]*Media size:.+\(([[:digit:]]+) bytes\).*$/\1/')
	EWFMD5=$(echo "$EWFINFO" | grep "MD5:" | $SEDCMD -r 's/^[[:space:]]*MD5:[[:space:]]+([[:digit:]a-fA-F]+).*$/\1/')
	if [ $DEBUG != 0 ]; then
		DEBUG "ewfinfo returned ($BYTES) bytes" "$0" "$LOG"
		DEBUG "ewfinfo returned original MD5: ($EWFMD5)" "$0" "$LOG"
	fi

	if [ $BYTES -gt 0 ]; then
		ewfexport -u -o 0 -B $BYTES -f raw -t "$RAW" "$EWF" | tee -a "$LOG"
		INFO "EWF-Stored MD5:				$EWFMD5" "$LOG"
	else
		ERROR "ewfinfo unable to retrieve bytes value!" "$0" "$LOG" && exit 1
	fi
else
	ERROR "Destination RAW already exists!" "$0" "$LOG" && exit 1
fi

