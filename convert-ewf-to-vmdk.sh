#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

EWF="$1"
VMDK="$2"
if [ $# -eq 0 ]; then
	USAGE "EWF" "VMDK" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

DEBUG=0
LOG="$VMDK.log"

if [ ! -e "$VMDK" ]; then
	EWFINFO=$(ewfinfo "$EWF" | tee -a "$LOG")

	BYTES=$(echo "$EWFINFO" | grep "Media size:" | $SEDCMD -r 's/^[[:space:]]*Media size:.+\(([[:digit:]]+) bytes\).*$/\1/')
	EWFMD5=$(echo "$EWFINFO" | grep "MD5:" | $SEDCMD -r 's/^[[:space:]]*MD5:[[:space:]]+([[:digit:]a-fA-F]+).*$/\1/')
	if [ $DEBUG != 0 ]; then
		DEBUG "ewfinfo returned ($BYTES) bytes" "$0" "$LOG"
		DEBUG "ewfinfo returned original MD5: ($EWFMD5)" "$0" "$LOG"
	fi

	if [ $BYTES -gt 0 ]; then
		ewfexport -u -o 0 -B $BYTES -f raw -t - "$EWF" | /Applications/VirtualBox.app/Contents/MacOS/VBoxManage convertfromraw stdin "$VMDK" $BYTES --format VMDK --variant Standard 2>&1 | tee -a "$LOG"
		RV=$((RV+$?))
		INFO "EWF-Stored MD5:				$EWFMD5" "$LOG"
	else
		ERROR "ewfinfo unable to retrieve bytes value!" "$0" "$LOG"
		RV=$COMMON_ERROR
	fi
else
	ERROR "Destination VMDK already exists!" "$0" "$LOG"
	RV=$COMMON_ERROR
fi

exit $RV

