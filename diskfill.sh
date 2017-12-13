#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" && exit 1
fi

BS=$("${BASH_SOURCE%/*}/blocksize.sh" "$DEVICE")
PATTERN="The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick br... "

INFO "Device: $DEVICE"
INFO "Block Size: $BS"
INFO "Pattern: '$PATTERN'"
INFO ""

INFO "Writing pattern to device ($DEVICE)..."
yes "$PATTERN" | dd bs="$BS" of="$DEVICE"

