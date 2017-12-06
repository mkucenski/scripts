#!/usr/bin/env bash

#ipfw -q flush; ipfw /etc/ipfw.rules
#ipfw reset

pfctl -f /etc/pf.conf

