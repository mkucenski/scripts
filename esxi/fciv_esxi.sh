#!/bin/ash

echo "//"
echo "// Open File Checksum Integrity Verifier version 1.0. (For ESXi Servers)"
echo "//"
echo "		MD5				SHA-1"
echo "-------------------------------------------------------------------------"
for arg in "$@"; do
	echo $(openssl dgst -md5 -r "$arg" 2>/dev/null | sed -r 's/(^.+) \*.*/\1/') "0000000000000000000000000000000000000000" "$arg"
done
