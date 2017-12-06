#!/usr/bin/env bash

for X in "$@"; do
	OLDEXT=`echo "$X" | egrep '.+\..{1,4}$' | gsed -r 's/^.+\.(.{1,4})$/\1/'`
	DESC=`file --brief "$X"`

	NEWEXT=""
	if [[ -n $DESC ]]; then
		if [[ -n `echo "$DESC" | grep "GIF image data"` ]]; then
			NEWEXT="gif"
		elif [[ -n `echo "$DESC" | grep "HTML document"` ]]; then
			NEWEXT="html"
		elif [[ -n `echo "$DESC" | grep "ASCII text"` ]]; then
			NEWEXT="txt"
		elif [[ -n `echo "$DESC" | grep "JPEG image data"` ]]; then
			NEWEXT="jpg"
		elif [[ -n `echo "$DESC" | grep "M3U playlist"` ]]; then
			NEWEXT="m3u"
		elif [[ -n `echo "$DESC" | grep "PNG image data"` ]]; then
			NEWEXT="png"
		elif [[ -n `echo "$DESC" | grep "XML 1.0 document"` ]]; then
			NEWEXT="png"
		else
			echo "Unknown extension for <$DESC>!"
		fi
	else
		echo "Missing file description!"
	fi

	if [[ -n $NEWEXT ]]; then
		if [[ -z $OLDEXT ]]; then
			mv -i -v "$X" "$X.$NEWEXT"
		else
			echo "File already has extension '$OLDEXT'!"
		fi
	fi
done

