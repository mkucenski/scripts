#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CSV="$1"
DELIM="$2"
FIELD_COUNT=$3
if [ $# -ne 3 ]; then
	USAGE "CSV" "DELIM" "FIELD_COUNT" && exit 1
fi

HEADER="$(head -n 1 "$CSV")"
SED="s/$DELIM/ | /g; s/^(.*)$/| \1 |/"

# Generate the header row and column alignment indicators (all centered)
echo "$HEADER" | $SEDCMD -r "$SED"
for X in $(seq 1 $FIELD_COUNT); do
	echo -n "| :---: "
done
echo "|"

while read -r LINE; do
	if [ "$LINE" != "$HEADER" ]; then
		echo "$LINE" | $SEDCMD -r "$SED"
	fi
done < "$CSV"

# | Date | Time | user | src_ip | dst_ip |
# | :--: | :--: | :--: | :----: | :----: |
# ||||||

