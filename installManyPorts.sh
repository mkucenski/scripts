#!/usr/bin/env bash

port=`echo "$1" | gsed -r 's/^([^ ]+) .*/\1/'`

cd "/usr/ports/$port"
if [ $? -eq 0 ]; then
	sudo make install clean
	if [ $? -eq 0 ]; then
	else
		echo "Adding to need.sh fetch list."
		sudo make fetch-recursive-list | fetch-to-wget.sh >> ~/portsFetch.sh
	fi
else
	echo "Invalid Port: $port"
fi

