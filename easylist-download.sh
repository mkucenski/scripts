#!/bin/bash

wget -N --directory-prefix=./easylist/ https://easylist.to/easylist/easylist.txt
wget -N --directory-prefix=./easylist/ https://easylist-downloads.adblockplus.org/easylist_noadult.txt
wget -N --directory-prefix=./easylist/ https://easylist-downloads.adblockplus.org/easylist_noelemhide.txt

comm -1 -2 ./easylist/easylist_noadult.txt ./easylist/easylist_noelemhide.txt > ./easylist/easylist_noadult-or-elemhide.txt

