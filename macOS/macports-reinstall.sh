#!/bin/sh

LOG="`echo ~`/Logs/macports-reinstall.log"

echo "" >> "$LOG"
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "Working Directory: `pwd`" >> "$LOG"
echo "Args: $@" >> "$LOG"
echo "" >> "$LOG"
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

# Save the list of installed ports:
INSTALLED=$(mktemp -t $(basename "$0")-installed)
$(dirname "$0")/macports-wrapper.sh -qv installed > "$INSTALLED"

# (optional) Save the list of requested ports:
REQUESTED=$(mktemp -t $(basename "$0")-requested)
$(dirname "$0")/macports-wrapper.sh echo requested | cut -d ' ' -f 1 > "$REQUESTED"

# Uninstall all installed ports:
$(dirname "$0")/macports-wrapper.sh -f uninstall installed

# Clean any partially-completed builds:
rm -rf /opt/local/var/macports/build/*

# Download and execute the restore_ports script:
TEMP=$(dirname $(mktemp))
SCRIPT="$TEMP/restore_ports.tcl"

pushd "$TEMP" && curl -O https://svn.macports.org/repository/macports/contrib/restore_ports/restore_ports.tcl
chmod +x "$SCRIPT"
popd
"$SCRIPT" "$INSTALLED"

# (optional) Restore requested status:
port unsetrequested installed
xargs port setrequested < "$REQUESTED"

POST=$(mktemp -t $(basename "$0")-post)
$(dirname "$0")/macports-wrapper.sh -qv installed > "$POST"
diff --side-by-side --suppress-common-lines "$INSTALLED" "$POST" | tee -a "$LOG"

rm "$INSTALLED" "$REQUESTED" "$SCRIPT" "$POST"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

