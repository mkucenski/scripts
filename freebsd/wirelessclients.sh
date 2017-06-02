#!/bin/sh

ifconfig ath0 list sta
ifconfig ath1 list sta | grep -v ADDR

echo ""

echo "ADDR                IP              NAME"
cat /var/db/dnsmasq.leases | gsed -r 's/^[^ ]+ ([^ ]+) ([^ ]+) ([^ ]+).*/\1   \2   \3/'

