#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

LOGFILE="$HOME/Logs/macports-wrapper-$(HOSTNAME).log"
ERR=-1
START "$0" "$LOGFILE" "$*"
LOG "Args: $(ECHO_ARGS $@)" "$LOGFILE"
port "$@" | tee -a "$LOGFILE"
END "$0" "$LOGFILE"
exit $ERR

