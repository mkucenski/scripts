#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Based on: https://www.cgsecurity.org/wiki/After_Using_PhotoRec#Using_a_shell_script_for_Mac_OS_X_and_Linux

RECUP_DIR="$(FULL_PATH "$1")"
LOGFILE="$RECUP_DIR/../photorec.log"
if [ $# -eq 0 ]; then
	USAGE "RECUP_DIR" && exit 1
fi

START "$0" "$LOGFILE" "$*"

TARGET_DIR="$RECUP_DIR.by_ext"
INFO "Sorting <$RECUP_DIR> by extension into <$TARGET_DIR>..." "$LOGFILE"
find "$RECUP_DIR" -type f | while read FILE; do
	FILE_NAME="$(basename "$FILE")"
	if [ "$FILE_NAME" != "report.xml" ]; then
		FILE_EXT="${FILE##*.}";
		EXTENSION_DIR="$TARGET_DIR/$FILE_EXT";
		if [ ! -d "$EXTENSION_DIR" ]; then
			echo "$EXTENSION_DIR"
			mkdir -p "$EXTENSION_DIR";
 		fi
		ln "$FILE" "$EXTENSION_DIR";
	fi
done 

if [ -n "$(which fdupes)" ]; then
	echo
	INFO "De-duplicating <$TARGET_DIR>..." "$LOGFILE"
	LOG_VERSION "fdupes" "$(fdupes --version)" "$LOGFILE"
	fdupes --recurse --delete --noprompt "$TARGET_DIR" | tee -a "$LOGFILE"
else
	WARNING "Unable to find 'fdupes'!" "$0" "$LOGFILE"
fi

END "$0" "$LOGFILE"

# Usage: fdupes [options] DIRECTORY...
# 
#  -r --recurse     	for every directory given follow subdirectories
#                   	encountered within
#  -R --recurse:    	for each directory given after this option follow
#                   	subdirectories encountered within (note the ':' at
#                   	the end of the option, manpage for more details)
#  -s --symlinks    	follow symlinks
#  -H --hardlinks   	normally, when two or more files point to the same
#                   	disk area they are treated as non-duplicates; this
#                   	option will change this behavior
#  -n --noempty     	exclude zero-length files from consideration
#  -A --nohidden    	exclude hidden files from consideration
#  -f --omitfirst   	omit the first file in each set of matches
#  -1 --sameline    	list each set of matches on a single line
#  -S --size        	show size of duplicate files
#  -m --summarize   	summarize dupe information
#  -q --quiet       	hide progress indicator
#  -d --delete      	prompt user for files to preserve and delete all
#                   	others; important: under particular circumstances,
#                   	data may be lost when using this option together
#                   	with -s or --symlinks, or when specifying a
#                   	particular directory more than once; refer to the
#                   	fdupes documentation for additional information
#  -N --noprompt    	together with --delete, preserve the first file in
#                   	each set of duplicates and delete the rest without
#                   	prompting the user
#  -I --immediate   	delete duplicates as they are encountered, without
#                   	grouping into sets; implies --noprompt
#  -p --permissions 	don't consider files with different owner/group or
#                   	permission bits as duplicates
#  -o --order=BY    	select sort order for output, linking and deleting; by
#                   	mtime (BY='time'; default) or filename (BY='name')
#  -i --reverse     	reverse order while sorting
#  -v --version     	display fdupes version
#  -h --help        	display this help message
# 
