#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

OUTPUTCSV="$1"
if [ $# -eq 0 ]; then
	USAGE "OUTPUTCSV" && exit 1
fi

SLEEPTIMER=10
HEADERCSV='"SSID","BSSID","RSSI","CHANNEL","HT","CC","SECURITY (auth/unicast/group)"'
HEADER="                            SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)"
RAWSCANDATA=$(MKTEMP "$0" || exit 1)
TMP=$(MKTEMP "$0" || exit 1)

# Trap Ctrl-C to complete the scan.
trap complete SIGINT
complete() {
	# Add the CSV version of the header to the output file.
	echo "$HEADERCSV" > "$OUTPUTCSV"

	# Break out the scan data into CSV format, then sort uniquely based on the SSID/BSSID and store in the output file.
	cat "$RAWSCANDATA" | \
		gsed -r 's/^[[:space:]]+(.+)[[:space:]]+([^[:space:]]+)[[:space:]]+([[:digit:]-]+)[[:space:]]+([[:digit:],+]+)[[:space:]]+(Y|N)[[:space:]]+([[:alpha:]-]{2})[[:space:]]+((WPA|WEP).*)$/"\1","\2","\3","\4","\5","\6","\7"/' | \
		csvquote -d "," | \
		sort -t "," -uk1,2 | \
		csvquote -d "," -u \
		>> "$OUTPUTCSV"

	echo; echo "$OUTPUTCSV"
	rm "$RAWSCANDATA"
	rm "$TMP"
   	exit
}

while true; do
	# Run the scan, stripping the header and saving the output
	airport -s | tail -n +2 | tee -a "$RAWSCANDATA" > "$TMP"

	clear; 
	echo "$HEADER"
	cat "$TMP"

	sleep $SLEEPTIMER
done

