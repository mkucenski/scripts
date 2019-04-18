#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
MCT_GZ="$3"

if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "MCT.GZ" && exit 1
	USAGE_DESCRIPTION "This script is a quick/dirty way to build a CSV mapping of 'Security IDs' to NTFS SID values for a given volume. It relies on a modified version of TSK that outputs the Security ID in the MCT owner record (TSK defaults to '0'). It assumes you have already extracted the MCT data via tsk_gettimes (or other) and stored them in a gzip compressed file."
fi

IFS=$(echo -en "\n\b")

# Find all unique Security IDs found in the MCT data
SECID_LIST="$(MKTEMP "$0")"
gunzip -c "$MCT_GZ" | cut -d "|" -f 5 | sort -un > "$SECID_LIST"

# Search the MCT data for each Security ID and retrieve it's inode; execute 'istat' to recover the SID value.
echo "Security ID,SID"
while read -r SECID; do
	SECID_MCT="$(gunzip -c "$MCT_GZ" | egrep "^[^|]*\|[^|]+\|[^|]+\|[^|]*\|$SECID\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$" | grep -v '$FILE_NAME' | head -n 1)"
	SECID_INODE="$(_tsk_mct_inode "$SECID_MCT" | cut -d "-" -f 1)"
	SECID_ISTAT="$(istat -o $OFFSET "$IMAGE" $SECID_INODE)"
	SID="$(_tsk_istat_sid "$SECID_ISTAT" | cut -d " " -f 3)"
	echo "$SECID,$SID"
done < "$SECID_LIST"

rm "$SECID_LIST"

