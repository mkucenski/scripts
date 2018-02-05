#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

IFS=$(echo -en "\n\b")

echo "//"
echo "// Open File Checksum Integrity Verifier version 1.0."
echo "//"
echo "		MD5				SHA-1"
echo "-------------------------------------------------------------------------"
for arg in "$@"; do
	"${BASH_SOURCE%/*}/fciv_worker.sh" "$arg" 0
done

