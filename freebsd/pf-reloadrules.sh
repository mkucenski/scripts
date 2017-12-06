#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "This script *MUST* be run as 'root'!" && exit 1
fi

pfctl -f /etc/pf.conf

