#!/bin/sh

#http://insecure.org/#conficker
#http://seclists.org/nmap-dev/2009/q1/0869.html

# Safe, default scan
#nmap -PN -T4 -p139,445 -n -v --script smb-check-vulns,smb-os-discovery --script-args safe=1 "$1" 2>&1

# Aggressive, more verbose scan
nmap -sC --script=smb-check-vulns --script-args=safe=1 -p445 -d -PN -n -T4 --min-hostgroup 256 --min-parallelism 64 -oA conficker_scan "$1" 2>&1

