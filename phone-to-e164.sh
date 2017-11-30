#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

PHONE="$1"
COUNTRY_CODE="$2"
SUFFIX="e164-addr.sip5060.net"
SUFFIX="e164.arpa"

COUNTRY_CODE="$(echo "$COUNTRY_CODE" | "$SEDCMD" -r s'/(.)/\1./g')"

echo "$PHONE" | "$SEDCMD" -r 's/[ ()-]//g;s/^0*//' | rev | "$SEDCMD" -r "s/(.)/\1./g;s/$/$COUNTRY_CODE$SUFFIX/"

