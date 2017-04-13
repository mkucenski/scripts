#!/bin/bash

FILE="$1"
SHA1="$2"

if [ "$SHA1" != "0" ]; then
	echo "$FILE" > /dev/stderr
	echo `openssl dgst -md5 -r "$FILE" | gsed -r 's/(^.+) \*.*/\1/'` `openssl dgst -sha1 -r "$FILE" | gsed -r 's/\*//;s/\//\\\/g'`
else
	echo "$FILE" > /dev/stderr
	echo `openssl dgst -md5 -r "$FILE" | gsed -r 's/(^.+) \*.*/\1/'` `echo "0000000000000000000000000000000000000000 *$FILE" | gsed -r 's/\*//;s/\//\\\/g'`
fi
