#!/bin/sh

pads -D -i fxp1 -w /usr/local/var/log/pads_fxp1_assets.csv -n 192.168.0.0/16
pads -D -i fxp0 -w /usr/local/var/log/pads_fxp0_assets.csv -n 192.168.1.0/24
pads -D -i ath0 -w /usr/local/var/log/pads_ath0_assets.csv -n 192.168.2.0/24
pads -D -i ath1 -w /usr/local/var/log/pads_ath1_assets.csv -n 192.168.3.0/24

