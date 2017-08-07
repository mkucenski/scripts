#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# Takes a list of IP addresses (one per line) on stdin and outputs the geographical location
# Uses software and databases found here: http://www.maxmind.com/app/ip-location

IP="$1"
if [ $# -eq 0 ]; then
	USAGE "IP" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

while `read IP`; do 
	Country=`geoiplookup $IP | gsed -r 's/^GeoIP Country Edition: (.+)/\1/'`
	City=`geoiplookup -f /usr/local/share/GeoIP/GeoLiteCity.dat $IP | gsed -r 's/GeoIP City Edition, Rev .: .., ([^,]+), ([^,]+), ([^,]+),.*/\1, \2, \3/'`
	echo "$IP		$Country, $City"
done

END "$0" "$LOGFILE"
exit $RV

