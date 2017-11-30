#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "MacPorts *MUST* be run as 'root'!" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

LOGFILE="$(echo ~)/Logs/macports-reinstall.log"

START "$0" "$LOGFILE" "$*"

# Save the list of installed ports:
LOG "Currently Installed:" "$LOGFILE"
INSTALLED=$(MKTEMP "$0-installed" || exit $COMMON_ERROR)
${BASH_SOURCE%/*}/macports-wrapper.sh -qv installed | tee "$INSTALLED" >> "$LOGFILE"

# (optional) Save the list of requested ports:
LOG "Requested:" "$LOGFILE"
REQUESTED=$(MKTEMP "$0-requested" || exit $COMMON_ERROR)
${BASH_SOURCE%/*}/macports-wrapper.sh echo requested | cut -d ' ' -f 1 | tee "$REQUESTED" >> "$LOGFILE"

# Uninstall all installed ports:
${BASH_SOURCE%/*}/macports-wrapper.sh -f uninstall installed

# Clean any partially-completed builds:
rm -rf /opt/local/var/macports/build/*

# Download and execute the restore_ports script:
_TMPDIR=$(MKTEMPDIR "$0")
SCRIPT="$_TMPDIR/restore_ports.tcl"

pushd "$_TMPDIR" && curl -O https://svn.macports.org/repository/macports/contrib/restore_ports/restore_ports.tcl
chmod +x "$SCRIPT"
popd
"$SCRIPT" "$INSTALLED"

# (optional) Restore requested status:
port unsetrequested installed
xargs port setrequested < "$REQUESTED"

POST=$(MKTEMP "$0-post" || exit $COMMON_ERROR)
${BASH_SOURCE%/*}/macports-wrapper.sh -qv installed > "$POST"
INFO $(diff --side-by-side --suppress-common-lines "$INSTALLED" "$POST") "$LOGFILE"

rm "$INSTALLED" "$REQUESTED" "$SCRIPT" "$POST"

END "$0" "$LOGFILE"

exit $RV

