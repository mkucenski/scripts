#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "This script *MUST* be run as 'root'!" && exit 1
fi

tcpdump -v -n -e -ttt -i pflog0 | gsed -r 's/bge0/<WAN>/g; s/bge1/<LAN>/g; s/tun0/<VPN>/g'

