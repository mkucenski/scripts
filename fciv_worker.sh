#!/bin/bash

FILE="$1"
echo `openssl dgst -md5 -r "$FILE" | gsed -r 's/(^.+) \*.*/\1/'` `openssl dgst -sha1 -r "$FILE" | gsed -r 's/\*//;s/\//\\\/g'`
