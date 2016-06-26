#!/usr/local/bin/bash

pushd /usr/ports/"$1"
if make extract; then
	find ./work -type f -iname "*changelog*" -exec less {} \;
else
	echo "Error extracting port archive." > /dev/stderr
fi

