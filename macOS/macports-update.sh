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

${BASH_SOURCE%/*}/macports-wrapper.sh installed > "$PRE"

INFO "$(${BASH_SOURCE%/*}/macports-wrapper.sh -d selfupdate)" "$LOGFILE"
INFO "$(${BASH_SOURCE%/*}/macports-wrapper.sh fetch outdated)" "$LOGFILE"
INFO "$(${BASH_SOURCE%/*}/macports-wrapper.sh -ucp upgrade outdated)" "$LOGFILE"

${BASH_SOURCE%/*}/macports-wrapper.sh installed > "$POST"
INFO $(diff --side-by-side --suppress-common-lines "$PRE" "$POST") "$LOGFILE"
rm "$PRE" "$POST"

END "$0" "$LOGFILE"

exit $RV

