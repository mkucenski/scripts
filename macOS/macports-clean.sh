#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "This script *MUST* be run as 'root'!" && exit 1
fi

LOGFILE="`echo ~`/Logs/macports-update-$(HOSTNAME).log"

START "$0" "$LOGFILE" "$*"
LOG "Args: $@" "$LOGFILE"

port -f clean --all all | tee -a "$LOGFILE"
port -f uninstall inactive | tee -a "$LOGFILE"

END "$0" "$LOGFILE"

