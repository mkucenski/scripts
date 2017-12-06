#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

pushd /usr/ports/"$1"
if make extract; then
	find ./work -type f -iname "*changelog*" -exec less {} \;
else
	echo "Error extracting port archive." > /dev/stderr
fi

