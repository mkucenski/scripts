#!/bin/sh

tcpdump -v -n -e -ttt -i pflog0 | gsed -r 's/bge0/<WAN>/g; s/bge1/<LAN>/g; s/tun0/<VPN>/g'

