#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 0

if [ $(CHECK_ROOT) != true ]; then
	ERROR "MacPorts *MUST* be run as 'root'!" && exit 0
fi

LOGFILE="`echo ~`/Logs/macports-reinstall.log"

ERR=-1
START "$0" "$LOGFILE"

LOG "Args: $@" "$LOGFILE"

# Save the list of installed ports:
INSTALLED=$(mktemp -t $(basename "$0")-installed)
${BASH_SOURCE%/*}/macports-wrapper.sh -qv installed > "$INSTALLED"

# (optional) Save the list of requested ports:
REQUESTED=$(mktemp -t $(basename "$0")-requested)
${BASH_SOURCE%/*}/macports-wrapper.sh echo requested | cut -d ' ' -f 1 > "$REQUESTED"

# Uninstall all installed ports:
${BASH_SOURCE%/*}/macports-wrapper.sh -f uninstall installed

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
${BASH_SOURCE%/*}/macports-wrapper.sh -qv installed > "$POST"
INFO $(diff --side-by-side --suppress-common-lines "$INSTALLED" "$POST") "$LOGFILE"

rm "$INSTALLED" "$REQUESTED" "$SCRIPT" "$POST"

END "$0" "$LOGFILE"
exit $ERR

