#!/bin/bash


for X in "$@"; do
	OLDEXT=`echo "$X" | grep "\." | gsed -r 's/^(.*)\.([^\.]+)$/\2/'`
	NEWEXT=`file --extension -b "$X" | gsed -r 's/^([^\/]+).*$/\1/'`
	DESC=`file -b "$X"`
	if [[ -z $OLDEXT ]]; then
		if [[ -z $NEWEXT ]]; then
			if [[ -n `echo "$DESC" | grep "GIF"` ]]; then
				NEWEXT="gif"
			elif [[ -n `echo "$DESC" | grep "Bitmap"` ]]; then
				NEWEXT="bmp"
			fi
		fi

		if [[ -n $NEWEXT ]]; then
			mv -i -v "$X" "$X.$NEWEXT"
		fi
	fi
done

