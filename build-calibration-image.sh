#!/bin/bash

DEVICE="$1"
SECTORS="$2"
SERIAL="$3"
LOG="$4"

SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BS=$(expr $SECTOR_SIZE \* 8)
COUNT=$(expr $SIZE / $BS)

echo "Building Calibration Drive ($1)..." | tee "$4"

echo "Device: $DEVICE" | tee -a "$4"
echo "512-byte Sectors: $SECTORS" | tee -a "$4"
echo "Disk Size: $SIZE" | tee -a "$4"
echo "Block Size: $BS" | tee -a "$4"
echo "Block Count: $COUNT" | tee -a "$4"

PATTERN="abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890abcdefghijklmnopqrstuvwxyz01234567890"

echo "" | tee -a "$4"
echo "Building expected MD5..." | tee -a "$4"
EXPECTED_MD5=`yes $PATTERN | dd bs=$BS count=$COUNT | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$EXPECTED_MD5 - MD5 Expected from Pattern Generation" | tee -a "$4"
EXPECTED_SHA1=`yes $PATTERN | dd bs=$BS count=$COUNT | openssl sha1 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$EXPECTED_SHA1 - SHA1 Expected from Pattern Generation" | tee -a "$4"

echo "" | tee -a "$4"
echo "Writing pattern to device ($DEVICE)..." | tee -a "$4"
yes $PATTERN | dd bs=$BS count=$COUNT of="$DEVICE"

echo "" | tee -a "$4"
echo "Reading from device ($DEVICE)..." | tee -a "$4"
DEVICE_MD5=`dd bs=$BS count=$COUNT if="$DEVICE" | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$4"

echo "" | tee -a "$4"
echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$4"
echo "$EXPECTED_MD5 - MD5 Expected from Pattern Generation" | tee -a "$4"
echo "$EXPECTED_SHA1 - SHA1 Expected from Pattern Generation" | tee -a "$4"

