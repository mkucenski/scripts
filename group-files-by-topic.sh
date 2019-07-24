#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# This is still a work in progress--the idea being to take a bunch of exported emails (or documents) and trim the names 
# down to something reasonably common so that files of similar topics can be sorted into same-name folders. 

SRC="$1"
DEST="$2"
if [ $# -eq 0 ]; then
	USAGE "SRC" "DEST" && exit 1
fi

LOGFILE="$DEST/$(STRIP_EXTENSION "$(basename "$0")").log"
mkdir -p "$DEST"
START "$0" "$LOGFILE" "$*"

function STRIP() {
	_STRIP_LINE="$1"
	_STRIP_DEST_FILE="$2"
	_STRIP_NEW_LINE="$_STRIP_LINE"

	while [ 1 ]; do
		_STRIP_NEW_LINE="$(echo "$_STRIP_LINE" | \
		 	$SEDCMD -r 's/^[-_.,!"()%#\&[:digit:][:space:]]*//;
		 					s/^\[(EXTERNAL|everyone|No Subject|Non-DoD Source)\][[:space:]]*//;
							s/^([rR][eE]|F[wW]d?|Automatic reply|Undeliverable|Recall)([_:]+| - )[[:space:]]*//;
							s/^Missed conversation with/Conversation with/;
							s/^IPM\..*//;
							s/^(NOT FOR DISTRIBUTION|IMPORTANT|Important|ANNOUNCEMENT|Announcement|DRAFT|Draft|EMAILING|Emailing|FINAL|Final|INFORMATION|Information|CONFIDENTIAL|Confidential)([_:]+| - )[[:space:]]*//;
							s/^(CORRECTION|Correction|COPY OF|Copy of|REMINDER|Reminder|FYI|Fyi|ATTENTION|Attention|URGENT|Urgent)([_:]+| - )[[:space:]]*//;
							s/^(NOTICE|Notice|PII|(INTERIM )?(UPDATE|Update)|(CONTAINS )?OUO|(URGENT |Urgent )?(Action|ACTION|Approval|APPROVAL)( Required| REQUIRED)?)([_:]+| - )[[:space:]]*//;
							s/( [Ff]or| [Aa]s [Oo]f|APPROVED|DONE|UPDATE|NEW|(REV|Rev|rev)|_+[PS]O)$//;
							s/( ?- ?| )(January|February|March|April|May|June|July|August|September|October|November|December)$//;
							s/ ?- ?(Sun|Mon|Tue|Wed|Thurs|Fri|Satur)day$//;
							s/\.[^.]{1,4}$//;
							s/[-_.,!"()%#\&[:digit:][:space:]]*$//')"	

		# If any changes were made, reiterate; if not, break and return
		if [ "$_STRIP_NEW_LINE" != "$_STRIP_LINE" ]; then
			_STRIP_LINE="$_STRIP_NEW_LINE"
		else
			break;
		fi
	done
	echo "$_STRIP_NEW_LINE" >> "$_STRIP_DEST_FILE"
}

INFO "Building lists of topics..." "$LOGFILE"
TOPICS_FILE="$(MKTEMP "$0" || exit 1)"; INFO_ERR "$TOPICS_FILE" "$LOGFILE"
TOPICS_FILE_TMP="$(MKTEMP "$0" || exit 1)"; INFO_ERR "$TOPICS_FILE_TMP" "$LOGFILE"
pushd "$SRC"
	ls > "$TOPICS_FILE"
	while read LINE; do
		# STRIP "$LINE" >> $TOPICS_FILE_TMP
		STRIP "$LINE" "$TOPICS_FILE_TMP"
	done < "$TOPICS_FILE"
	sort -bfiu "$TOPICS_FILE_TMP" | egrep -v "^$" > "$TOPICS_FILE"
	vi "$TOPICS_FILE"
popd

# Further sort the topics list based on the length of the topic string. This ensures that files are matched and moved
# to the most specific topic first before some very short (say a 1 or 2 letter) topic matches everything.
cat "$TOPICS_FILE" | sort -bfiu | $AWKCMD '{ print length, $0 }' | sort -nr | cut -d " " -f2- > "$TOPICS_FILE_TMP"; mv "$TOPICS_FILE_TMP" "$TOPICS_FILE"
vi "$TOPICS_FILE"

INFO "Making a copy of the src directory so that each file can be moved into place as appropriate..." "$LOGFILE"
# Copying the source directory because we as we sort, we need to remove the file from the source directory so that it 
# doesn't get matched multiple times by less specific (say 1 or 2 letter) topics. However, by working off of a copy,
# the actual source directory doesn't get modified.
SRC_COPIES="$(MKTEMPDIR "$0" || exit 1)"
cp -R "$SRC/" "$SRC_COPIES"

INFO "Reading topics file and moving files into appropriate sub-folders..." "$LOGFILE"
# Read each topic and then find any file that matches; move the files into that sub-folder.
while read -r LINE; do
	# INFO_ERR "$LINE" "$LOGFILE"
	mkdir -p "$DEST/$LINE"
	find "$SRC_COPIES" -type f -depth 1 -iname "*$LINE*" -exec mv {} "$DEST/$LINE/" \;
done < "$TOPICS_FILE"

INFO "Deleting any empty sub-folders that may have been inadvertently created..." "$LOGFILE"
# It's possible that after user-trimming and matching we end up with topic folders that get created, but all matching
# files have been moved to something more specific; this just gets rid of those extraneous folders.
find "$DEST" -type d -empty -exec rmdir {} \; 2>/dev/null

# Finally, if there are any files left in the source copy, then we've managed to somehow not match those files to any
# topics. They have to be copied somewhere so that they are available for review; copy them to an unknown folder.
if [ -n "$(ls -A "$SRC_COPIES/")" ]; then 
	# OTHER_DIR="$DEST/[$(basename "$0") - Other]"
	OTHER_DIR="$DEST/[Other-Unknown Topics]"
	INFO "Copying missed files into <$OTHER_DIR>..." "$LOGFILE"
	mkdir -p "$OTHER_DIR"
	cp -R "$SRC_COPIES/" "$OTHER_DIR/"
fi

INFO "Cleaning up temp files/folders..." "$LOGFILE"
rm -f "$TOPICS_FILE"
rm -f "$TOPICS_FILE_TMP"
rm -Rf "$SRC_COPIES"

END "$0" "$LOGFILE"

