#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
if [ $# -ne 1 ]; then
	USAGE "DEVICE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

COUNT=1
# BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")
BS=512
SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
SECTOR_SIZE=512
SIZE=$(($SECTORS * $SECTOR_SIZE))
BLOCKS=$(($SIZE / $BS))

INFO "Head: $($BS * $COUNT))-bytes of ($DEVICE) using (bs=$BS)"
dd if="$DEVICE" bs=$BS count=$COUNT 2>/dev/null | xxd -a
INFO ""
 
INFO "Middle: $(($BS * $COUNT))-bytes of ($DEVICE) using (bs=$BS, skip=$(($BLOCKS / 2 - $COUNT / 2)) -> $(printf "%'d\n" $(($BS * ( $BLOCKS / 2 - $COUNT / 2 )))))"
dd if="$DEVICE" bs=$BS skip=$(($BLOCKS / 2 - $COUNT / 2)) count=$COUNT 2>/dev/null | xxd -a
INFO ""

INFO "Tail: $(($BS * $COUNT))-bytes of ($DEVICE) using (bs=$BS, skip=$(($BLOCKS - $COUNT)) -> $(printf "%'d\n" $(($BS * ( $BLOCKS - $COUNT )))))"
dd if="$DEVICE" bs=$BS skip=$(($BLOCKS - $COUNT)) count=$COUNT 2>/dev/null | xxd -a
INFO ""

exit $RV

