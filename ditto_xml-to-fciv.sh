#!/bin/bash

XML="$1"

# 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12345678
# 6B2D73F7A8FBCA104CBA51EFEE59A582 0000000000000000000000000000000000000000 $MFT
KEY="1.75"

if [ -e "$XML" ]; then
	$(dirname "$0")/fciv.sh
	grep "^<entry>" "$XML" | grep "<md5>" | gsed -r 's/^.+<name>(.+)<\/name>.+<md5>(.+)<\/md5>.+$/\2 0000000000000000000000000000000000000000 .\\\\\1/' | sort --key=$KEY
else
	echo "Error! Unable to find file!" > /dev/stderr
fi
