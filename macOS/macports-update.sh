#!/bin/sh

LOG="`echo ~`/Logs/macports-update.log"

echo "" >> "$LOG"
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "Working Directory: `pwd`" >> "$LOG"
echo "Args: $@" >> "$LOG"
echo "" >> "$LOG"

PRE="$TMPDIR/pre-ports.txt"
POST="$TMPDIR/post-ports.txt"

$(dirname "$0")/macports-wrapper.sh installed > "$PRE"

$(dirname "$0")/macports-wrapper.sh -d selfupdate
$(dirname "$0")/macports-wrapper.sh fetch outdated
$(dirname "$0")/macports-wrapper.sh -ucp upgrade outdated

$(dirname "$0")/macports-wrapper.sh installed > "$POST"
diff --side-by-side --suppress-common-lines "$PRE" "$POST" | tee -a "$LOG"
rm "$PRE" "$POST"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

