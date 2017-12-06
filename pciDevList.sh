#!/usr/bin/env bash

# pciconf -lv | grep -A 1 -B1 "device"

# pciconf -lv | grep -A 2 -B 1 "device" | gsed -r "s/^\s+vendor\s+=\s+'(.+)'$/\1/;s/^\s+device\s+=\s+'(.+)'$/\1/;s/^\s+class\s+=\s+(.+)$/\1/;s/^\s+subclass\s+=\s+(.+)/\1/"

# pciconf -lv | grep -A 2 -B 1 'device' | tr '\n' '\t' | gsed 's/--\t/\n/g' | gsed -r "s/^\s+vendor\s+=\s+'([^\t]+)'\t\s+device\s+=\s+'([^\t]+)'\t\s+class\s+=\s+([^\t]+)\t\s+subclass\s+=\s+([^\t]+)\t/\4: \2\n\t\1\n/"

pciconf -lv | gsed -r 's/^.+\@.*/--\n&/' | tr '\n' '\t' | gsed 's/--\t/\n/g' | gsed -r "s/^(.+)@(.+):\s+(.+)\t\s+vendor\s+=\s+'([^\t]+)'\t\s+device\s+=\s+'([^\t]+)'\t\s+class\s+=\s+([^\t]+)\t\s+subclass\s+=\s+([^\t]+)\t/\7: \5\n\t\4\n\t\6\n\t\1\n\t\2\n\t\3\n/"

