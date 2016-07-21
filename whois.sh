#!/bin/bash

# Run whois records consistently store the results in a specific directory

SITE="$1"
DEST="$2"

whois "$SITE" | tee -a "$DEST/$SITE-whois.txt"

