#! /bin/sh
### BEGIN INIT INFO
# Provides:          debianShutdownNotify.sh
# Required-Start:    $local_fs $remote_fs
# Default-Start:     0 6
# Short-Description: Example initscript
# Description:       This script runs at shutdown and reboot to notify the MAILTO 
#                    address of the shutdown/reboot event
### END INIT INFO

# Author: Matthew A. Kucenski

PATH=/sbin:/usr/sbin:/bin:/usr/bin
EXEC=/usr/bin/mail

# Exit if the package is not installed
[ -x "$EXEC" ] || exit 0

MAILTO=""

DATE=`date +"%b %d %T"`
HOSTNAME=`hostname -f`

$EXEC -s "Shutdown/Reboot Initiated" $MAILTO << EOF
$DATE: A shutdown or reboot action was initiated on $HOSTNAME.
EOF

# Sleep to give the message time to be sent before the system stops
sleep 10

:
