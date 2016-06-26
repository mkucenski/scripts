#!/bin/sh

# Check for network connectivity to CCD Lab firewall
if /bin/ping -c 1 192.168.42.1 > /dev/null 2>&1; then
	#/usr/bin/apt-get -qq update
	/usr/bin/aptitude -q -q update | \
		/bin/grep -v "Reading package lists\.\.\."

	# Check for out-of-date packages
	/usr/bin/aptitude -sy upgrade | \
		/bin/grep -A 10 "The following packages will be upgraded:" | \
		/bin/sed -r 's/The following packages will be upgraded:/The following packages have updates available:/'

else
	# Check for forensic network IP.
	#    Do not report errors on forensic network.
	IP=`/sbin/ifconfig | /bin/grep "inet addr" | /bin/grep -v "127\.0\.0\.1" | /bin/sed -r 's/[[:space:]]+inet addr:([^[:space:]]+).*/\1/'`
	if echo "$IP" | /bin/grep -v "^10\.10\.1\."; then 
		echo "Unable to verify Internet connectivity."
	fi
fi

