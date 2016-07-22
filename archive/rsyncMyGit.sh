#!/bin/bash

mounted=`mount | grep "MyCloud._afpovertcp._tcp.local/Development"`
if [ -n "$mounted" ]; then
	rsync -av ~/Development/MyGit /Volumes/Development/MyGit\ Backup
fi
