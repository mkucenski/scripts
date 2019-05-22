#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DIR="$1"
OUTFILE="$2"
if [ $# -eq 0 ]; then
	USAGE "DIR" "OUTFILE" && exit 1
fi

function output() {
	echo "$1" >> "$DIR/$OUTFILE"
}

rm -f "$DIR/$OUTFILE"

output "<html>"
output "	<head>"
output "		<title>$(basename "$(pwd)")</title>"
output "	</head>"
output "	<body>"
output "		<h1>$(basename "$(pwd)")</h1>"

if [ -e "$DIR/OutlookHeaders.txt" ]; then
	output "		<pre>$(cat "$DIR/OutlookHeaders.txt")</pre>"
fi

output "		<ol>"
find "$DIR" -type d -depth 1 -print0 |
while IFS= read -r -d $'\0' X; do
	NAME=$(basename "$X")
	output "			<li><a href='$NAME/$(basename "$OUTFILE")'>$NAME</a></li>"
done

find "$DIR" -type f -depth 1 -print0 |
while IFS= read -r -d $'\0' X; do
	NAME=$(basename "$X")
	if [ "$NAME" != "$(basename "$OUTFILE")" ]; then
		output "			<li><a href='$NAME'>$NAME</a></li>"
	fi
done
output "		</ol>"

output "	</body>"
output "</html>"

