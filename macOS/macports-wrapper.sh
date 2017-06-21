#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 0

if [ $(CHECK_ROOT) != true ]; then
	ERROR "MacPorts *MUST* be run as 'root'!" && exit 0
fi

LOGFILE="`echo ~`/Logs/macports-wrapper.log"

ERR=-1
START "$0" "$LOGFILE"

LOG "Args: $@" "$LOGFILE"

INFO "$(port "$@" 2>&1)" "$LOGFILE"

END "$0" "$LOGFILE"
exit $ERR

