#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1
ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

RV=$COMMON_SUCCESS

echo "//"
echo "// Open File Checksum Integrity Verifier version 1.0."
echo "//"
echo "		MD5				SHA-1"
echo "-------------------------------------------------------------------------"
for arg in "$@"; do
	${BASH_SOURCE%/*}/fciv_worker.sh "$arg" 1
	RV=$((RV+$?))
done

exit $RV

