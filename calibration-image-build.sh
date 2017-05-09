#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
TESTMODE="$4"
if [ $# -ne 4 ]; then
	USAGE "DEVICE" "SERIAL" "LOGDIR" "TESTMODE" && exit 0
fi

LOGFILE="$LOGDIR/$SERIAL-calibration.log"
START "$0" "$LOGFILE"
  
if [ -n "$TESTMODE" ]; then
	WARNING "Test mode enabled, results will not be written to / read from disk!" "$0" "$LOGFILE"
fi

SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
if [ $SECTORS -lt 0 ]; then
	ERROR"Unable to read disk sectors!" "$0" "$LOGFILE"
	END "$0" "$LOGFILE"
	exit 1
fi

SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")
COUNT=$(expr $SIZE / $BS)
PATTERN="The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick br... "
PATTERN_LEN=$(expr ${#PATTERN} + 1)

LOG "Building Calibration Drive ($DEVICE)..." "$LOGFILE"
LOG "Device: $DEVICE" "$LOGFILE"
LOG "512-byte Sectors: $SECTORS" "$LOGFILE"
LOG "Disk Size: $SIZE" "$LOGFILE"
LOG "Block Size: $BS" "$LOGFILE"
LOG "Block Count: $COUNT" "$LOGFILE"
LOG "Pattern: '$PATTERN'" "$LOGFILE"
LOG "Pattern Bytes: $PATTERN_LEN" "$LOGFILE"
LOG "" "$LOGFILE"

LOG "Building expected MD5..." "$LOGFILE"
EXPECTED_MD5=`yes "$PATTERN" | dd ibs=$PATTERN_LEN obs=$BS count=$(expr $SIZE / $PATTERN_LEN) | openssl md5 | tr a-z A-Z | $SEDCMD -r 's/\(STDIN\)= //'`
LOG "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
LOG "" "$LOGFILE"

if [ -z "$TESTMODE" ]; then
	LOG "Writing calibration pattern to device ($DEVICE)..." "$LOGFILE"
	yes $PATTERN | dd bs=$BS of="$DEVICE"
	LOG "" "$LOGFILE"

	LOG "Reading from device ($DEVICE)..." "$LOGFILE"
	DEVICE_MD5=$(${BASH_SOURCE%/*}/diskmd5.sh "$DEVICE" "$BS")
	if [ -n "$DEVICE_MD5" ]; then
		LOG "$DEVICE_MD5 - MD5 read from device ($DEVICE)" "$LOGFILE"
		LOG "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
		if [ "$DEVICE_MD5" == "$EXPECTED_MD5" ]; then
			LOG "Match!" "$LOGFILE"
		fi
		LOG "" "$LOGFILE"
		END "$0" "$LOGFILE"
		exit 0
	else
		ERROR "Unable to read MD5 from device!" "$0" "$LOGFILE"
	fi
else
		WARNING "Test mode enabled, results not written to / read from disk!" "$0" "$LOGFILE"
fi

END "$0" "$LOGFILE"
exit 1
