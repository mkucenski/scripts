#!/usr/bin/env bash

# $1 File system type
# $2 Partition offset
# $3 Destination directory
# $4 Image(s)

echo "\"$0\", \"$1\", \"$2\", \"$3\", \"$4\", \"$5\", \"$6\", \"$7\", \"$8\", \"$9\", \"${10}\""

if [ $1 != "RECURSE" ]; then
	ilsRegex='^[^\|]+\|<(.+)-(dead|alive)-[[:digit:]]+>\|[^\|]+\|([^\|]+)\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+\|[^\|]+$'

	if [ ! -e "$3" ]; then
		mkdir -p "$3"
	fi
	if [ ! -e "$3/Info" ]; then
		mkdir -p "$3/Info"
	fi

	if [ $# -gt 4 ]; then
		IMAGES="-i split"
		i=4
		while [ $i -le $# ]; do
			echo "$i"
			echo "${!i}"
			let "i+=1" > /dev/null
		done
		exit
	else
		IMAGES="$4"
	fi

	echo "Retrieving all deleted/orphaned files..."
	#ils -m -f $1 -o $2 "$IMAGES" | egrep "$ilsRegex" | gsed -r "s/$ilsRegex/\3 \"\3-\1\"/" | xargs -L 1 -J {} "$0" RECURSE $1 $2 "$3" {} "$4" 
	echo "$IMAGES"
	ils -m -f $1 -o $2 "$IMAGES" | egrep "$ilsRegex" | gsed -r "s/$ilsRegex/\3 \"\3-\1\"/"

	echo "Removing zero byte files..."
	find "$3" -type f -size 0 -exec rm {} \;

	echo "Done."
else
	# $1 "RECURSE"
	# $2 File system type
	# $3 Partition offset
	# $4 Destination directory
	# $5 Inode
	# $6 Filename
	# $7 Image(s)

	if [ ! -e "$4/$6" ]; then
		echo "$4/$6"
		icat -r -f $2 -o $3 "$7" $5 > "$4/$6"
		istat -f $2 -o $3 "$7" $5 > "$4/Info/$6.info"
		#strings -t d "$4/$6" > "$4/Info/$6.str.tmp"
		#strings -t d -e l "$4/$6" >> "$4/Info/$6.str.tmp"
		#sort -u "$4/Info/$6.str.tmp" > "$4/Info/$6.str"
		#rm "$4/Info/$6.str.tmp"
	else
		echo "ERROR: File <$4/$6> already exists!"
	fi
fi

