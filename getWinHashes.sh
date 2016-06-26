#!/bin/sh

if [ -n "$1" ]; then
	if [ -f "$1" ]; then
		if [ -n "$2" ]; then
			if [ -f "$2" ]; then
				bkhive "$1" /dev/stdout | samdump2 "$2" /dev/stdin 2> /dev/null
				exit
			else
				echo "$2: not found"
				exit 0
			fi
		fi
	else
		echo "$1: not found"
		exit 0
	fi
fi

echo "usage: `basename $0` SysRegFile SAMRegFile"

