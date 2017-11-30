#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Takes a list of IP addresses (one per line) on stdin or via a text file argument.
# Uses software and databases found here: http://www.maxmind.com/app/ip-location.

DBDIR="/opt/local/share/GeoIP"

RV=$COMMON_SUCCESS

while read IP; do 
	COUNTRY="$(geoiplookup -f "$DBDIR/GeoLiteCountry.dat" $IP | $SEDCMD -r 's/^GeoIP Country Edition: (.+)/\1/; s/, /,/g')"
	CITY="$(geoiplookup -f "$DBDIR/GeoLiteCity.dat" $IP | gsed -r 's/GeoIP City Edition, Rev .: .., ([^,]+), ([^,]+), ([^,]+),.*/\1, \2, \3/; s/, /,/g')"

	echo -n "$IP,"
	if [ -z "$(echo "$COUNTRY" | grep "IP Address not found")" ]; then
		echo -n "$COUNTRY,"
	else
		echo -n "UNK,UNK,"
	fi
	if [ -z "$(echo "$CITY" | grep "IP Address not found")" ]; then
		echo "$CITY"
	else
		echo "UNK,UNK,UNK"
	fi
done < "${1:-/dev/stdin}"

exit $RV

