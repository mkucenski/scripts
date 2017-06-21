#!/bin/bash

MSG="$1"
TITLE="$2"
osascript -e "\'display notification "$MSG" with title "$TITLE"\'"
