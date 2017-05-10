#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

EWF="$1"
RAW="$2"
if [ $# -eq 0 ]; then
	USAGE "EWF" "RAW" && exit 0
fi

DEBUG=0
LOG="$RAW.log"

if [ ! -e "$RAW" ]; then
	EWFINFO=$(ewfinfo "$EWF" | tee -a "$LOG")

	BYTES=$(echo "$EWFINFO" | grep "Media size:" | $SEDCMD -r 's/^[[:space:]]*Media size:.+\(([[:digit:]]+) bytes\).*$/\1/')
	EWFMD5=$(echo "$EWFINFO" | grep "MD5:" | $SEDCMD -r 's/^[[:space:]]*MD5:[[:space:]]+([[:digit:]a-fA-F]+).*$/\1/')
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

