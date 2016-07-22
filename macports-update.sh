#!/bin/sh

LOG="`echo ~`/Logs/macports-update.log"

echo "" >> "$LOG"
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "Working Directory: `pwd`" >> "$LOG"
echo "Args: $@" >> "$LOG"
echo "" >> "$LOG"

PRE="$TMPDIR/pre-ports.txt"
POST="$TMPDIR/post-ports.txt"

port-wrapper.sh installed > "$PRE"

port-wrapper.sh -d selfupdate
port-wrapper.sh fetch outdated
port-wrapper.sh -ucp upgrade outdated

port-wrapper.sh installed > "$POST"
diff "$PRE" "$POST" | tee -a "$LOG"
rm "$PRE" "$POST"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

