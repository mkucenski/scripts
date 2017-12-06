#!/usr/bin/env bash

cat /var/log/auth.log | grep "Invalid user" | gsed -r 's/.* (([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3})$/\1/' > /tmp/blockedIPs.txt

bunzip2 -c /var/log/auth*.bz2 | grep "Invalid user" | gsed -r 's/.* (([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3})$/\1/' >> /tmp/blockedIPs.txt

cat /etc/pf.blocked >> /tmp/blockedIPs.txt

cat /tmp/blockedIPs.txt | sort -u | tee /etc/pf.blocked

~/Scripts/reloadFirewallRules.sh 

