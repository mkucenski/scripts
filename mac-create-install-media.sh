#!/bin/bash

# (e.g. /Applications/Install\ OS\ X\ Yosemite.app)
INSTALLAPP="$1"

# (e.g. /Volumes/Untitled)
DESTVOL="$2"

if [ -e "$DESTVOL" ]; then
	SCRIPT="$INSTALLAPP/Contents/Resources/createinstallmedia"
	"$SCRIPT" --volume "$DESTVOL" --applicationpath "$INSTALLAPP" --nointeraction
else
	echo "Destination Volume doesn't exist!"
fi

