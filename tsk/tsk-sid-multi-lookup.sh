#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
SECID_LIST="$3"
MCT_GZ="$4"
CSV="$5"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "SECID_LIST" "MCT.GZ" && exit 1
fi

IFS=$(echo -en "\n\b")

echo "Security ID,SID"
while read -r SECID; do
	SECID_MCT="$(gunzip -c "$MCT_GZ" | egrep "^[^|]*\|[^|]+\|[^|]+\|[^|]*\|$SECID\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$" | grep -v '$FILE_NAME' | head -n 1)"
	SECID_INODE="$(_tsk_mct_inode "$SECID_MCT" | cut -d "-" -f 1)"
	SECID_ISTAT="$(istat -o $OFFSET "$IMAGE" $SECID_INODE)"
	SID="$(_tsk_istat_sid "$SECID_ISTAT" | cut -d " " -f 3)"
	echo "$SECID,$SID"
done < "$SECID_LIST"

