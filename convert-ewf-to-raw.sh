#!/bin/bash

EWF="$1"
RAW="$2"

DEBUG=0
LOG="$RAW.log"

if [ ! -e "$RAW" ]; then
	EWFINFO=$(ewfinfo "$EWF" | tee -a "$LOG")

	BYTES=$(echo "$EWFINFO" | grep "Media size:" | gsed -r 's/^[[:space:]]*Media size:.+\(([[:digit:]]+) bytes\).*$/\1/')
	EWFMD5=$(echo "$EWFINFO" | grep "MD5:" | gsed -r 's/^[[:space:]]*MD5:[[:space:]]+([[:digit:]a-fA-F]+).*$/\1/')
	if [ $DEBUG != 0 ]; then
		echo "$0: DEBUG: ewfinfo returned ($BYTES) bytes" | tee -a "$LOG"
		echo "$0: DEBUG: ewfinfo returned original MD5: ($EWFMD5)" | tee -a "$LOG"
	fi

	if [ $BYTES -gt 0 ]; then
		ewfexport -u -o 0 -B $BYTES -f raw -t "$RAW" "$EWF" | tee -a "$LOG"
		echo "EWF-Stored MD5:				$EWFMD5" | tee -a "$LOG"
	else
		echo "$0: ewfinfo unable to retrieve bytes value!" | tee -a "$LOG"
	fi
else
	echo "$0: Destination RAW already exists!" | tee -a "$LOG"
fi

