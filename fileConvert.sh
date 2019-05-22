#!/usr/bin/env bash

# USAGE:
# $1 File to convert
# $2 Destination directory

# The purpose behind this script is to automate converting various types of files into their text components 
# to facilitate keyword searching.  If a specialized program is available it should be used, otherwise revert
# to using strings.  Skip all text files as they can already be searched directly.

# Ultimately, this should be the basis for a system that imports an evidence item's text into a database and
# then indexes the text for searching.

name=`basename "$1"`
dir=`dirname "$1"`
type=`file -ib "$1" | gsed -r 's/^(.+)\/(.+)/\1/`

echo "$1"
case "$type" in
	"text" )
	;;
	"application" )
		if [ ! -e "$2/$dir" ]; then
			mkdir -p "$2/$dir"
		fi
		subtype=`file -ib "$1" | gsed -r 's/^(.+)\/(.+)/\2/`
		case "$subtype" in 
			"msword" )
				catdoc "$1" > "$2/$dir/$name.catdoc.txt"
				xls2csv "$1" > "$2/$dir/$name.xls2csv.txt"
			;;
			"pdf" )
				pdftotext "$1" "$2/$dir/$name.pdftotext.txt"
			;;
			"x-bzip2" | "x-gzip" | "x-tar" | "x-zip" )
				cp "$1" "$2/$dir/"
			;;
			#"octet-stream" )
			# TODO figure out how to distiguish further and run things like
			# winLnkViewer and winEventViewer
			#;;
			* )
				strings -e s "$1" > "$2/$dir/$name.strings.txt"
				strings -e l "$1" >> "$2/$dir/$name.strings.txt"
				#strings -e L "$1" >> "$2/$dir/$name.strings.txt"
			;;
		esac
	;;
	* )
		if [ ! -e "$2/$dir" ]; then
			mkdir -p "$2/$dir"
		fi
		strings -e s "$1" > "$2/$dir/$name.strings.txt"
		strings -e l "$1" >> "$2/$dir/$name.strings.txt"
		#strings -e L "$1" >> "$2/$dir/$name.strings.txt"
	;;
esac



