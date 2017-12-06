#!/usr/bin/env bash

for IP in `pfctl -t bruteforce -T show | gsed -r 's/^[[:space:]]+(.+)/\1/'`; do
	Country=`geoiplookup $IP | gsed -r 's/^GeoIP Country Edition: (.+)/\1/'`
	City=`geoiplookup -f /usr/local/share/GeoIP/GeoLiteCity.dat $IP | gsed -r 's/GeoIP City Edition, Rev .: .., ([^,]+), ([^,]+), ([^,]+),.*/\1, \2, \3/'`
	echo "$IP		$Country, $City"
done

