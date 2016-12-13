#!/bin/bash

# Wrapper to consistently run photorec for carving files

IMAGE="$1"
DEST="$2"

LOG="$DEST/photorec_wrapper.log"

if [ ! -e "$DEST" ]; then
	mkdir -p "$DEST"
fi

echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "CMD: '$0 $@'" >> "$LOG"
cat "$0" | gsed -r 's/^/>>   /' >> "$LOG"

photorec /version >> "$LOG" 2>> "$LOG"
photorec /log /d "$DEST" "$IMAGE" 2>> "$LOG"
mv photorec.* "$DEST/" 2>&1 >> "$LOG"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

