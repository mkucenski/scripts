#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 0

if [ $(CHECK_ROOT) != true ]; then
	ERROR "MacPorts *MUST* be run as 'root'!" && exit 0
fi

LOGFILE="`echo ~`/Logs/macports-update.log"

ERR=-1
START "$0" "$LOGFILE"

LOG "Args: $@" "$LOGFILE"

PRE=$(mktemp)
POST=$(mktemp)

${BASH_SOURCE%/*}/macports-wrapper.sh installed > "$PRE"

INFO "$(${BASH_SOURCE%/*}/macports-wrapper.sh -d selfupdate)" "$LOGFILE"
INFO "$(${BASH_SOURCE%/*}/macports-wrapper.sh fetch outdated)" "$LOGFILE"
INFO "$(${BASH_SOURCE%/*}/macports-wrapper.sh -ucp upgrade outdated)" "$LOGFILE"

${BASH_SOURCE%/*}/macports-wrapper.sh installed > "$POST"
INFO $(diff --side-by-side --suppress-common-lines "$PRE" "$POST") "$LOGFILE"
rm "$PRE" "$POST"

END "$0" "$LOGFILE"
exit $ERR

