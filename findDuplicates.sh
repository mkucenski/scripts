#!/bin/sh

if [ $# -eq 1 ]; then
	find "$1" -type f -exec "$0" "$1" {} \;
else
	if [ $# -eq 2 ]; then
		FILE=`basename "$2"`
		find "$1" -type f -name "$FILE" -exec "$0" "$1" "$2" {} \;
	else
		if [ "$2" != "$3" ]; then
			if [ -f "$2" ]; then
				if [ -f "$3" ]; then
					MD51=`md5 -q "$2"`
					MD52=`md5 -q "$3"`
					echo "1:   $2"
					echo "2:   $3"
					if [ $MD51 != $MD52 ]; then
						echo "MD5 Mismatch!"
					else	
						echo "Delete #1 or #2? "
						read CHOICE
						if [ $CHOICE = "1" ]; then
							rm "$2"
						else 
							if [ $CHOICE = "2" ]; then
								rm "$3"
							else
								echo "Invalid choice"
							fi
						fi
					fi
					echo ""
				fi
			fi
		fi
	fi
fi

