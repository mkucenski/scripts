#~/bin/bash

FILE="$1"

git checkout $(git rev-list -n 1 HEAD -- "$FILE")^ -- "$FILE"

