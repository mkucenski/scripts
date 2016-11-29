#!/bin/sh

LOG="`echo ~`/Logs/macports-update.log"

echo "" >> "$LOG"
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "Working Directory: `pwd`" >> "$LOG"
echo "Args: $@" >> "$LOG"
echo "" >> "$LOG"

PRE="$TMPDIR/pre-ports.txt"
POST="$TMPDIR/post-ports.txt"

macports-wrapper.sh installed > "$PRE"

macports-wrapper.sh -d selfupdate
macports-wrapper.sh fetch outdated
macports-wrapper.sh -ucp upgrade outdated

macports-wrapper.sh installed > "$POST"
diff -y "$PRE" "$POST" | tee -a "$LOG"
rm "$PRE" "$POST"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

