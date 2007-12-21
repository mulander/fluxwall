#!/bin/bash
# fluxwall installer version 1.6
# coded by mulander & w3b
# contact: netprobe@gmail.com & w3b@da-mail.net
# This program is distrubuted under the GPL


if [ $UID -eq 0 ]
	then
	echo "Don't run this script as root - it is not needed"
	exit 1
fi

	echo -n "checking if /usr/bin/fbsetbg exists..."
if [ -e "/usr/bin/fbsetbg" ]
	then
	echo "yes"
	echo -n "checking if user has executable permissions to /usr/bin/fbsetbg..."
	if [ -x "/usr/bin/fbsetbg" ]
		then
		echo "yes"
		else
		echo "no"
		echo "In order for fluxwall to properly run the user using it must be able to execute /usr/bin/fbsetbg"
		exit 1
	fi
	else
	echo "no"
	echo "fluxwall uses fbsetbg to change wallpapers - I can't find it in /usr/bin/fbsetbg"
	echo "please install fbsetbg to continue"
	exit 1
fi
	echo -n "checking if wallpaper directory is set..."
cat fluxwall.pl | grep /home/mulander/graphics/wallpapers 1>/dev/null
if  [ $? -eq 0 ]
	then
	echo "no"
	echo "Before running this script change your wallpaper directory!"
	echo "You can do this by editing this line in fluxwall.pl:"
	echo "my \$walldir	= shift || '/home/mulander/graphics/wallpapers'; # change to your wallpaper directory"
	echo -e "\t\t\t\t^"
	echo -e "\t\tPlace your wallpaper directory path here"
	exit 1
	else
	echo "yes"
fi
	echo -n "checking if $HOME/.fluxbox directory exists..."
if [ -e "$HOME/.fluxbox" ]
	then
	echo "yes"
	echo -n "checking if $HOME/.fluxbox/menu exists..."
		if [ -e "$HOME/.fluxbox/menu" ]
			then
			echo "yes"
			echo -n "checking if fluxwall is already installed..."
if [ -e "$HOME/.fluxbox/wallmenu" -o -e "$HOME/.fluxbox/fluxwall.pl" -o -e "$HOME/.fluxbox/fluxwall-last.sh" ]
				then
				echo yes
				echo fluxwall is already installed, please uninstall before running $0
				echo -n "uninstall fluxwall now? [anwser: yes/no default: yes] "
				read anwser
					case $anwser in
					n*|N*)
						echo installation aborted
						exit 1
					;;
					*)
						./fluxwall-uninstall.sh			
					esac
				else
				echo no
			fi

			else
			echo "no"
			echo "You must have a menu file in order to properly install this script"
			exit 1
		fi
	else
	echo "no"
	echo "You must have $HOME/.fluxbox directory in order to properly install this script"
fi

	echo copying files:
	echo -n fluxwall.pl...
if cp fluxwall.pl 	$HOME/.fluxbox/fluxwall.pl
	then
	echo ok
	else
	echo not ok
	exit 1
fi

	echo -n wallmenu...
if cp wallmenu	$HOME/.fluxbox/wallmenu
	then
	echo ok
	else
	echo not ok
	exit 1
fi

	echo setting executive permissions:
	echo -n fluxwall.pl...
if chmod 700 $HOME/.fluxbox/fluxwall.pl
	then
	echo ok
	else
	echo not ok
	exit 1
fi

cd $HOME/.fluxbox/
	echo -n creating a backup_menu...
if cp menu backup_menu
	then
	echo done
	else
	echo failed
	echo "Can't create a backup of $HOME/.fluxbox/menu"
	exit 1
fi

echo -n preparing new menu...
	echo "[begin] (fluxbox)" > menu.bak
	echo "[exec] (Refresh Fluxwall) {$HOME/.fluxbox/fluxwall.pl} <>" >> menu.bak
	echo "[include] ($HOME/.fluxbox/wallmenu)" >> menu.bak
	cat menu | grep -v "\[begin\]" >> menu.bak
echo done
echo -n installing new menu...
if	mv menu.bak menu
	then
	echo done
	else
	echo failed
fi

echo -n checking if $HOME/.fluxbox/startup exists...
if [ -e "$HOME/.fluxbox/startup" ]
	then
	echo yes
	
	echo -n installing fluxwall-last.sh in startup...
	perl -i.bak -pe 'print "sh $ENV{HOME}/.fluxbox/fluxwall-last.sh &\n" if /^exec.+fluxbox/i' startup
	if egrep "$HOME/\.fluxbox/fluxwall-last\.sh &" startup 1> /dev/null
		then
		echo ok

		else 
		echo not ok
		echo it seems that we failed to install in startup...
		echo remembering wallpapers on reboot may not work
		echo you are strongly advised to review $HOME/.fluxbox/startup
		echo you can retrieve your old backup, it is stored in $HOME/.fluxbox/startup.bak
	fi

	else
	echo no
	echo fluxwall will not be able to restore the last choosen wallpaper on startup
	echo please enable the startup file in $HOME/.fluxbox/ and reinstall if you need this feature
	echo -n removing previously copied fluxwall-last.sh...
	if rm $HOME/.fluxbox/fluxwall-last.sh
		then
		echo ok
		
		else
		echo not ok
		echo something went wrong and you will have to remove $HOME/.fluxbox/fluxwall-last.sh manualy
		echo you can ignore this error as it is not critical
	fi
fi
	echo fluxwall installed
exit 0
