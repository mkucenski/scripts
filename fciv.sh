#!/bin/bash

echo "//"
echo "// Open File Checksum Integrity Verifier version 1.0."
echo "//"
echo "		MD5				SHA-1"
echo "-------------------------------------------------------------------------"
for arg in "$@"; do
	echo `openssl dgst -md5 -r "$arg" | gsed -r 's/(^.+) \*.*/\1/'` `openssl dgst -sha1 -r "$arg" | gsed -r 's/\*//;s/\//\\\/g'`
done
