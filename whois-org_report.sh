#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# This script parses the output of "whois.sh" into a CSV format showing the IP and OrgName.
# It expects the specific output from my "whois.sh", not any whois output.

WHOIS_DIR="$1"
if [ $# -eq 0 ]; then
	USAGE "WHOIS_DIR" && exit 1
fi

if [ -e "$WHOIS_DIR" ]; then
	find "$WHOIS_DIR" -type f -print0 |
	while IFS= read -r -d $'\0' WHOIS_FILE; do
		"${BASH_SOURCE%/*}/whois-org_report_worker.sh" "$WHOIS_FILE"
	done
else
	ERROR "Whois dir doesn't exist!" "$0" && exit 1
fi

