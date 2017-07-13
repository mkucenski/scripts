#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "MacPorts *MUST* be run as 'root'!" && exit $COMMON_ERROR
fi

LOGFILE="`echo ~`/Logs/macports-update.log"

RV=$COMMON_SUCCESS

START "$0" "$LOGFILE"
LOG "Args: $@" "$LOGFILE"

PRE=$(MKTEMP "$0" || exit $COMMON_ERROR)
POST=$(MKTEMP "$0" || exit $COMMON_ERROR)

port installed > "$PRE"

port -d selfupdate | tee -a "$LOGFILE"
port fetch outdated | tee -a "$LOGFILE"
port -ucp upgrade outdated | tee -a "$LOGFILE"

port installed > "$POST"
diff --side-by-side --suppress-common-lines "$PRE" "$POST" | tee -a "$LOGFILE"
rm "$PRE" "$POST"

END "$0" "$LOGFILE"

exit $RV

