#!/usr/bin/env bash

# $1 File system type
# $2 Partition offset
# $3 Image
# $4 Destination directory
# $5 Starting inode

if [ $# -eq 5 ]; then
	flsRegex='^([rd-])\/([rd-])[[:space:]]+(\*)?[[:space:]]*([[:digit:]]+)(-[[:digit:]-]+)?(\(realloc\))?:[[:space:]]+(.+)$'

	if [ ! -e "$4" ]; then
		mkdir -p "$4"
	fi

	INODE=""
	if [ ! $5 -eq 0 ]; then
		INODE=$5
	fi

	echo "Retrieving files..."
	fls -f $1 -o $2 -Frp "$3" $INODE | tee /tmp/recoverFilesStatus.log | egrep "$flsRegex" | gsed -r "s/$flsRegex/\4 \"\7\"/" | xargs -L 1 "$0" $1 $2 "$3" "$4" - 
	echo "Done."
else
	# $6 Inode
	# $7 Filepath

	if [ ! $6 -eq 0 ]; then
		FILEDIR=`dirname "$7"`
		if [ ! -e "$4/$FILEDIR" ]; then
			mkdir -p "$4/$FILEDIR"
		fi
		FILENAME=`basename "$7"`

		if [ ! -e "$4/$FILEDIR/$FILENAME" ]; then
			echo "$4/$FILEDIR/$FILENAME"
			icat -r -f $1 -o $2 "$3" $6 > "$4/$FILEDIR/$FILENAME"
		else
			if [ ! -e "$4/$FILEDIR/$6-$FILENAME" ]; then
				echo "$4/$FILEDIR/$6-$FILENAME"
				icat -r -f $1 -o $2 "$3" $6 > "$4/$FILEDIR/$6-$FILENAME"
			else
				echo "ERROR: File <$4/$FILEDIR/$6-$FILENAME> already exists!" > /dev/stderr
			fi
		fi
	else
		echo "ERROR: File <$7> is linked to inode 0!" > /dev/stderr
	fi
fi

