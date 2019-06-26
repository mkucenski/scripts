#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# This is still a work in progress--the idea being to take a bunch of exported emails (or documents) and trim the names 
# down to something reasonably common so that files of similar topics can be sorted into same-name folders. 

SRC="$1"
DEST="$2"
if [ $# -eq 0 ]; then
	USAGE "SRC" "DEST" && exit 1
fi

INFO "Building lists of topics..."
TOPICS_FILE="$(MKTEMP "$0" || exit 1)"
TOPICS_FILE_TMP="$(MKTEMP "$0" || exit 1)"
pushd "$SRC"
# Attempt to remove leading email-type strings (reply, forward, etc.) as well as removing \. file extensions and
# any "stuff" after them (the meat of the name/topic is likely prior to any file extensions).
# Attempt to remove other random email subject nonsense.
# Attempt to removing any leading/trailing numbers, dashes, periods, commas, etc.
# Escape any \[ or \] since they cause 'find' to incorrectly match filenames
ls | $SEDCMD -r 's/(\[EXTERNAL\]|(Automatic reply|[rR][eE]|F[wW]d?|Undeliverable|Recall)[_:]) *//g; s/\.(pdf|xlsx?|XLSX?|docx?|DOCX?).*//g' | \
	$SEDCMD -r 's/(IMPORTANT|(INTERIM )? (UPDATE|Update)|Announcement|DRAFT|Emailing|FINAL|Information|CONFIDENTIAL|CORRECTION|Copy of|(CONTAINS )?OUO|Reminder|REMINDER|FYI|(Action|Approval) Required|ATTENTION|(URGENT )?ACTION( REQUIRED)?|URGENT)[_:]+ *//g' | \
	$SEDCMD -r 's/^Missed conversation with/Conversation with/' | \
	$SEDCMD -r 's/\[(everyone|No Subject|Non-DoD Source)\]//g' | \
	$SEDCMD -r 's/^IPM\..*//' | \
	$SEDCMD -r 's/^[-_.,!"()%#[:digit:][:space:]]*//g; s/[-_.,!"()%#[:digit:][:space:]]*$//g' | \
	$SEDCMD -r 's/_DONE$//' | \
	$SEDCMD -r 's/\[/\\[/g; s/\]/\\]/g' | \
	egrep -v "^$" | \
	sort -bfiu > "$TOPICS_FILE_TMP"

	# Give the user a chance to edit/further trim the topics list
	vi "$TOPICS_FILE_TMP"
popd
exit 0

# Further sort the topics list based on the length of the topic string. This ensures that files are matched and moved
# to the most specific topic first before some very short (say a 1 or 2 letter) topic matches everything.
cat "$TOPICS_FILE_TMP" | sort -bfiu | $AWKCMD '{ print length, $0 }' | sort -nr | cut -d " " -f2- > "$TOPICS_FILE"
rm "$TOPICS_FILE_TMP"

INFO "Making a copy of the src directory so that each file can be moved into place as appropriate..."
# Copying the source directory because we as we sort, we need to remove the file from the source directory so that it 
# doesn't get matched multiple times by less specific (say 1 or 2 letter) topics. However, by working off of a copy,
# the actual source directory doesn't get modified.
SRC_COPIES="$(MKTEMPDIR "$0" || exit 1)"
cp -R "$SRC/" "$SRC_COPIES"

INFO "Reading topics file and moving files into appropriate sub-folders..."
# Read each topic and then find any file that matches; move the files into that sub-folder.
while read -r LINE; do
	INFO "$LINE"
	mkdir -p "$DEST/$LINE"
	find "$SRC_COPIES" -type f -depth 1 -iname "*$LINE*" -exec mv {} "$DEST/$LINE/" \;
done < "$TOPICS_FILE"

INFO "Deleting any empty sub-folders that may have been inadvertently created..."
# It's possible that after user-trimming and matching we end up with topic folders that get created, but all matching
# files have been moved to something more specific; this just gets rid of those extraneous folders.
find "$DEST" -type d -empty -exec rmdir {} \; 2>/dev/null

# Finally, if there are any files left in the source copy, then we've managed to somehow not match those files to any
# topics. They have to be copied somewhere so that they are available for review; copy them to an unknown folder.
if [ -n "$(ls -A "$SRC_COPIES/")" ]; then 
	# OTHER_DIR="$DEST/[$(basename "$0") - Other]"
	OTHER_DIR="$DEST/[Unknown Topic]"
	INFO "Copying missed files into <$OTHER_DIR>..."
	mkdir -p "$OTHER_DIR"
	cp -R "$SRC_COPIES/" "$OTHER_DIR/"
fi

INFO "Cleaning up temp files/folders..."
rm "$TOPICS_FILE"
rm -R "$SRC_COPIES"

exit 0

