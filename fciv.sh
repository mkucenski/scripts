#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

RV=$COMMON_SUCCESS

echo "//"
echo "// Open File Checksum Integrity Verifier version 1.0."
echo "//"
echo "		MD5				SHA-1"
echo "-------------------------------------------------------------------------"
for arg in "$@"; do
	${BASH_SOURCE%/*}/fciv_worker.sh "$arg"
	RV=$((RV+$?))
done

exit $RV

