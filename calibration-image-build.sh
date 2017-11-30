#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
TESTMODE="$4"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIAL" "LOGDIR" "TESTMODE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

LOGFILE="$LOGDIR/$SERIAL-calibration.log"
START "$0" "$LOGFILE" "$*"
  
if [ -n "$TESTMODE" ]; then
	WARNING "Test mode enabled, results will not be written to / read from disk!" "$0" "$LOGFILE"
fi

SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
if [ $SECTORS -lt 0 ]; then
	ERROR"Unable to read disk sectors!" "$0" "$LOGFILE"
	END "$0" "$LOGFILE"
	exit $COMMON_ERROR
fi

SECTOR_SIZE=512
SIZE=$(($SECTORS * $SECTOR_SIZE))
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")
COUNT=$(($SIZE / $BS))
PATTERN="The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick br... "
PATTERN_LEN=$((${#PATTERN} + 1))

INFO "Building Calibration Drive ($DEVICE)..." "$LOGFILE"
INFO "Device: $DEVICE" "$LOGFILE"
INFO "512-byte Sectors: $SECTORS" "$LOGFILE"
INFO "Disk Size: $SIZE" "$LOGFILE"
INFO "Block Size: $BS" "$LOGFILE"
INFO "Block Count: $COUNT" "$LOGFILE"
INFO "Pattern: '$PATTERN'" "$LOGFILE"
INFO "Pattern Bytes: $PATTERN_LEN" "$LOGFILE"
INFO "" "$LOGFILE"

INFO "Building expected MD5..." "$LOGFILE"
EXPECTED_MD5=$(yes "$PATTERN" | dd ibs=$PATTERN_LEN obs=$BS count=$(($SIZE / $PATTERN_LEN)) | openssl md5 | tr a-z A-Z | $SEDCMD -r 's/\(STDIN\)= //')
INFO "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
INFO "" "$LOGFILE"

if [ -z "$TESTMODE" ]; then
	INFO "Writing calibration pattern to device ($DEVICE)..." "$LOGFILE"
	yes "$PATTERN" | dd bs=$BS of="$DEVICE"
	INFO "" "$LOGFILE"

	INFO "Reading from device ($DEVICE)..." "$LOGFILE"
	DEVICE_MD5=$(${BASH_SOURCE%/*}/diskmd5.sh "$DEVICE" "$BS")
	if [ -n "$DEVICE_MD5" ]; then
		INFO "$DEVICE_MD5 - MD5 read from device ($DEVICE)" "$LOGFILE"
		INFO "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
		if [ "$DEVICE_MD5" == "$EXPECTED_MD5" ]; then
			INFO "Match!" "$LOGFILE"
		fi
	else
		ERROR "Unable to read MD5 from device!" "$0" "$LOGFILE"
		RV=$COMMON_ERROR
	fi
else
	WARNING "Test mode enabled, results not written to / read from disk!" "$0" "$LOGFILE"
fi

END "$0" "$LOGFILE"

exit $RV

