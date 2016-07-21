#!/bin/bash

# Run whois records with the given server and consistently store the results in a specific directory

SITE="$1"
SERVER="$2"
DEST="$3"

whois -h "$SERVER" "$SITE" | tee -a "$DEST/$SITE-whois.txt"

