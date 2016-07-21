#!/bin/bash

# Consistently run photorec for carving images

# "$1" = data to carve
# "$2" = destination

photorec /version > "$2/photorec_version.txt"
photorec /log /d "$2" "$1"

