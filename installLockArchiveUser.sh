#!/bin/sh

cp lockArchiveUser.sh /usr/local/bin/
chown root:wheel /usr/local/bin/lockArchiveUser.sh
chmod ug=rx,o= /usr/local/bin/lockArchiveUser.sh
ls -l /usr/local/bin/lockArchiveUser.sh

