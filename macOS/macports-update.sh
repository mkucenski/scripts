#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "This script *MUST* be run as 'root'!" && exit 1
fi

LOGFILE="`echo ~`/Logs/macports-update.log"

START "$0" "$LOGFILE" "$*"
LOG "Args: $@" "$LOGFILE"

PRE=$(MKTEMP "$0" || exit 1)
POST=$(MKTEMP "$0" || exit 1)

port installed > "$PRE"

port -d selfupdate | tee -a "$LOGFILE"
port fetch outdated | tee -a "$LOGFILE"
port -ucp upgrade outdated | tee -a "$LOGFILE"

port installed > "$POST"
diff --side-by-side --suppress-common-lines "$PRE" "$POST" | tee -a "$LOGFILE"
rm "$PRE" "$POST"

END "$0" "$LOGFILE"

