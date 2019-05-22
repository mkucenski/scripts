#!/usr/bin/env bash
#
# Dependency : gdialog (gnome-utils) 

SRM=`which srm`

if [ -n "$SRM" ]; then
	if [ -f "$1" ]; then
		if `zenity --question --text "Are you sure you want to securely delete this file? You will not be able to recover from this action."`; then
			if `srm "$1" | zenity --progress --pulsate --auto-close --auto-kill --text "Securely deleting '$1'..."`; then
				zenity --info --text "'$1' successfully deleted."
			else
				zenity --error --text "Failure deleting '$1'."
			fi
		fi
	elif [ -d "$1" ]; then
		if `zenity --question --text "Are you sure you want to securely delete this folder and all files/subfolders? You will not be able to recover from this action."`; then
			if `srm -R "$1" | zenity --progress --pulsate --auto-close --auto-kill --text "Securely deleting '$1'..."`; then
				zenity --info --text "'$1' successfully deleted."
			else
				zenity --error --text "Failure deleting '$1'."
			fi
		fi
	else
		zenity --error --text "Unknown file type for '$1'."
	fi
else
	zenity --error --text "Unable to find 'srm' executable."
fi
 
