#!/bin/bash

echo "//"
echo "// Open File Checksum Integrity Verifier version 1.0."
echo "//"
echo "		MD5				SHA-1"
echo "-------------------------------------------------------------------------"
for arg in "$@"; do
	$(dirname "$0")/fciv_worker.sh "$arg"
done
