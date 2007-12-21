#!/bin/bash
# fluxwall uninstaller version 1.6
# coded by mulander & w3b
# contact: netprobe@gmail.com & w3b@da-mail.net
# This program is distrubuted under the GPL


if [ $UID -eq 0 ]
	then
	echo "Don't run this script as root - it is not needed"
	exit 1
fi


if [ -e "$HOME/.fluxbox/wallmenu" -a -e "$HOME/.fluxbox/fluxwall.pl" ] || [ -e "$HOME/.fluxbox/fluxwall-last.sh" ]
	then

		echo -n "Removing wallmenu..."
		if rm $HOME/.fluxbox/wallmenu
			then
			echo ok
			
			else
			echo not ok
			exit 1
		fi 

		echo -n "Removing fluxwall.pl..."
		if rm $HOME/.fluxbox/fluxwall.pl
			then
			echo ok
			
			else
			echo not ok
			exit 1
		fi
# if the file is present, try to remove it.
if [ -e "$HOME/.fluxbox/fluxwall-last.sh" ]
	then
		echo -n "Removing fluxwall-last.sh..."
		if rm $HOME/.fluxbox/fluxwall-last.sh
			then
			echo ok

			else
			echo not ok
		fi
fi
		echo -n "Checking if fluxwall-last.sh was installed in startup..."
if [ -e "$HOME/.fluxbox/startup" ]
	then
		if egrep "$HOME/\.fluxbox/fluxwall-last\.sh &" $HOME/.fluxbox/startup 1> /dev/null
			then
			echo yes
			echo -n removing fluxwall-last.sh from startup...
				cat $HOME/.fluxbox/startup | egrep -v "$HOME/\.fluxbox/fluxwall-last\.sh &" > $HOME/.fluxbox/fw_temp
				mv $HOME/.fluxbox/fw_temp $HOME/.fluxbox/startup
			echo done
			
			else
			echo no
		fi
	else
	echo no
fi

	echo -n "Removing fluxwall from menu..."
	cat $HOME/.fluxbox/menu | egrep -v "Fluxwall|wallmenu" > $HOME/.fluxbox/fw_temp
	mv $HOME/.fluxbox/fw_temp $HOME/.fluxbox/menu
	echo done

echo fluxwall uninstalled

	else
	echo fluxwall is not installed - aborting
	exit 1
fi
