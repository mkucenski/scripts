#!/usr/local/bin/bash

base=11
limit=254

echo "begin"
for ((a=0; a<=$limit; a++)); do
	echo "$base.$a.0.0" > /dev/stderr
	for ((b=0; b<=$limit; b++)); do
		for ((c=1; c<=$limit; c++)); do
			echo "$base.$a.$b.$c"
		done
	done
done
echo "end"
		
