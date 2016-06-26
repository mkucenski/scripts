#!/bin/bash

NEW=`echo "$1" | gsed -r "s/$2/$3/"`
echo "$NEW"

if [ "$1" != "$NEW" ]
then
	echo "Moving:" "$1" "$NEW"
	cp "$1" "$NEW"
fi

