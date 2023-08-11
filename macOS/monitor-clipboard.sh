#!/usr/bin/env bash
#. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

# Continually run `pbpaste` checking each time to see if new data has been copied by the user

x=""
while true; do 
	y=`pbpaste`
	if [ "$x" != "$y" ]; then
		echo $y
		x=$y
	fi
done

