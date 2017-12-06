#!/usr/bin/env bash

# https://easylist.to/index.html
# https://easylist.to/pages/other-supplementary-filter-lists-and-easylist-variants.html
# http://www.malwaredomains.com/?p=251

# Fetch the newest versions of EasyList
wget -N --directory-prefix=./easylist/ https://easylist.to/easylist/easylist.txt
wget -N --directory-prefix=./easylist/ https://easylist-downloads.adblockplus.org/easylist_noadult.txt
wget -N --directory-prefix=./easylist/ https://easylist-downloads.adblockplus.org/easylist_noelemhide.txt
wget -N --directory-prefix=./easylist/ https://easylist-downloads.adblockplus.org/malwaredomains_full.txt

# Combine the 'noadult' and 'noelemhide' to create a simplified list of only basic URL-based ads.
comm -1 -2 ./easylist/easylist_noadult.txt ./easylist/easylist_noelemhide.txt > ./easylist/easylist_noadult-or-elemhide.txt

