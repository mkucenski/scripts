#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# This script parses the output of "whois.sh" into a CSV format showing the IP and OrgName.
# It expects the specific output from my "whois.sh", not any whois output.

WHOIS_FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "WHOIS_FILE" && exit 1
fi

if [ -e "$WHOIS_FILE" ]; then
	SITE="$(grep "Whois Query for:" "$WHOIS_FILE" | gsed -r 's/Whois Query for:[[:space:]]+(.+)/\1/')"

	# Attempt to pull out "OrgName", ARIN reports the info we need right here.
	ORG="$(grep -i "OrgName:" "$WHOIS_FILE" | $SEDCMD -r 's/OrgName:[[:space:]]+(.+)/\1/')"
	if [ -n "$ORG" ]; then

		# If ARIN says someone else is responsible, try and pull out their version of the org name.
		if [ "$ORG" == "Asia Pacific Network Information Centre" ]; then
			ORG="$(grep -i "descr:" "$WHOIS_FILE" | $SEDCMD -r 's/descr:[[:space:]]+(.+)/\1/' | head -n 1)"
		elif [ "$ORG" == "RIPE Network Coordination Centre" ]; then
			ORG="$(grep -i "descr:" "$WHOIS_FILE" | $SEDCMD -r 's/descr:[[:space:]]+(.+)/\1/' | head -n 1)"
		elif [ "$ORG" == "African Network Information Center" ]; then
			ORG="$(grep -i "descr:" "$WHOIS_FILE" | $SEDCMD -r 's/descr:[[:space:]]+(.+)/\1/' | head -n 1)"
		elif [ "$ORG" == "Latin American and Caribbean IP address Regional Registry" ]; then
			ORG="$(grep -i "owner:" "$WHOIS_FILE" | $SEDCMD -r 's/owner:[[:space:]]+(.+)/\1/' | head -n 1)"
		fi
	fi

	# Attempt to pull out "Country", ARIN reports the info we need right here.
	COUNTRY="$(grep -i "Country:" "$WHOIS_FILE" | $SEDCMD -r 's/Country:[[:space:]]+(.+)/\1/')"
	if [ -n "$COUNTRY" ]; then

		# If ARIN says someone else is responsible, try and pull out their version of the org name.
		if [ "$COUNTRY" == "Asia Pacific Network Information Centre" ]; then
			COUNTRY="$(grep -i "Country:" "$WHOIS_FILE" | $SEDCMD -r 's/Country:[[:space:]]+(.+)/\1/')"
		elif [ "$COUNTRY" == "RIPE Network Coordination Centre" ]; then
			COUNTRY="$(grep -i "Country:" "$WHOIS_FILE" | $SEDCMD -r 's/Country:[[:space:]]+(.+)/\1/')"
		elif [ "$COUNTRY" == "African Network Information Center" ]; then
			COUNTRY="$(grep -i "Country:" "$WHOIS_FILE" | $SEDCMD -r 's/Country:[[:space:]]+(.+)/\1/')"
		elif [ "$COUNTRY" == "Latin American and Caribbean IP address Regional Registry" ]; then
			COUNTRY="$(grep -i "Country:" "$WHOIS_FILE" | $SEDCMD -r 's/Country:[[:space:]]+(.+)/\1/')"
		fi
	fi

	# If we found something, output in CSV
	if [ -n "$ORG" ]; then
		echo -n "$SITE,\"$ORG\""
		if [ -n "$SERVER" ]; then
			echo -n ",\"(via $SERVER)\""
		fi
		echo ",$COUNTRY"
	else
		# If we still didn't find anything, then try to output each line of the data that is there--it often seems to be useful in figuring out the org.
		ORG="$(egrep -v "(Whois Query for|START|END|ARGS|BASE64)" < "$WHOIS_FILE" | egrep -v "^$" | tr "\n" "|" | $SEDCMD -r 's/\|$/"/; s/\|/","/g; s/(.*)/"\1/')"
		echo "$SITE,$ORG,$COUNTRY"
	fi
else
	ERROR "Whois file doesn't exist!" "$0" && exit 1
fi

