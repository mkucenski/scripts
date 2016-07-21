#!/bin/bash

# useful in processing text data that includes non-standard characters; '-c' silently discards non-convertable characters.

iconv -c -t ASCII "$1"

