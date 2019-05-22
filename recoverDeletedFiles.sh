#!/usr/bin/env bash

# $1 File system type
# $2 Partition offset
# $3 Image
# $4 Destination directory

#echo "\"$0\", $1, $2, \"$3\", \"$4\", $5, \"$6\""

if [ $# -eq 4 ]; then
	ilsRegex='^[^\|]+\|<(.+)-(dead|alive)-[[:digit:]]+>\|[^\|]+\|([^\|]+)\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+$'

	if [ ! -e "$4" ]; then
		mkdir -p "$4"
	fi
	if [ ! -e "$4/Info" ]; then
		mkdir -p "$4/Info"
	fi

	echo "Retrieving all deleted/orphaned files..."
	ils -m -f $1 -o $2 "$3" | egrep "$ilsRegex" | gsed -r "s/$ilsRegex/\3 \"\3-\1\"/" | xargs -L 1 "$0" $1 $2 "$3" "$4"

	echo "Removing zero byte files..."
	find "$4" -type f -size 0 -exec rm {} \;

	echo "Done."
else
	# $5 Inode
	# $6 Filename

	if [ ! -e "$4/$6" ]; then
		echo "$4/$6"
		icat -r -f $1 -o $2 "$3" $5 > "$4/$6"
		istat -f $1 -o $2 "$3" $5 > "$4/Info/$6.info"
		#strings -t d "$4/$6" > "$4/Info/$6.str.tmp"
		#strings -t d -e l "$4/$6" >> "$4/Info/$6.str.tmp"
		#sort -u "$4/Info/$6.str.tmp" > "$4/Info/$6.str"
		#rm "$4/Info/$6.str.tmp"
	else
		echo "ERROR: File <$4/$6> already exists!"
	fi
fi

