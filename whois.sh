#!/bin/bash

# Run whois records consistently store the results in a specific directory

DOMAIN="$1"
DEST="$2"

whois "$DOMAIN" | tee -a "$DEST/$DOMAIN-whois.txt"

