#!/bin/bash

####### TechTutors DDRescue Script ########
####### For internal use only!     ########

FIRSTNAME=
LASTNAME=
CONFIRM=n
CLIENTNAME=
DATE=`date +%Y-%m-%d-%H`

clear
echo -e "---------------------------"
echo -e "TechTutor's DDRescue Script"
echo -e "--------------------------- \n"

while true; do
	echo -e "First Name: \c "
	read FIRSTNAME

	echo -e "Last Name: \c "
	read LASTNAME

	echo -e "You entered \e[1m$FIRSTNAME $LASTNAME\e[0m. Is this correct? [Y/n] \c "
	read -n1 CONFIRM
	: ${CONFIRM:=y}
	echo

	case ${CONFIRM,,} in
		y|Y) break;;
		*) echo -e "Please retry... \n";;
	esac
done


CLIENTNAME=$LASTNAME-$FIRSTNAME
echo -e "Client: $CLIENTNAME\n"
while true; do
	CONFIRM=
	echo -e "Please choose a disk from the following: "
	ttrtmpfile=/tmp/ttrescue
	if [ -f "$ttrtmpfile" ]; then
		rm $ttrtmpfile
	fi
	find /dev/disk/by-id -type l ! \( -iname '*part*' -o -iname '*wwn*' -o -iname '*DVD*' -o -iname '*S26EJ9AB201025*' -o -iname '*ZFN0D6XP*' -o -iname '*WD-WCASY5758938*' \) > /tmp/ttrescue.txt

	x=1
	echo -e "${choice[$x]}"
	while IFS='' read -r line || [[ -n "$line" ]]; do
	            choice[$x]=$line
	            echo -e "$x: ${choice[$x]}"
	            x=`expr $x + 1`
	    done < /tmp/ttrescue.txt

	echo -e "\nPlease enter a number (1-`expr $x - 1`): \c "
	read DISKNUM

	DISKNAME=${choice[$DISKNUM]}

	CONFIRM=y
	echo -e "\nYou chose \e[1m$DISKNAME\e[0m. Is that correct? [Y/n] \c "
		read -n1 CONFIRM
		: ${CONFIRM:=y}
		echo

		case ${CONFIRM,,} in
			y|Y) break;;
			*) echo -e "Please retry... \n";;
		esac
	done


echo -e "\n\n-------------------------------------------------------------------------------\n"
echo -e "Client Name: \e[1m$CLIENTNAME\e[0m"
echo -e "Disk to be recovered: \e[1m$DISKNAME\e[0m\n"
echo -e "Going to run the following commands: \n"
echo -e "\e[1msudo ddrescue -n $DISKNAME /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.img /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.log\e[0m"
echo -e "\e[1msudo ddrescue -r3 $DISKNAME /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.img /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.log\e[0m"
echo ""

while true; do
CONFIRM=
echo -e "\e[1m$!!! ABOUT TO START!!! \e[0mAre you sure you want to do this? [y/n] \c "
	read -n1 CONFIRM
	echo

	case ${CONFIRM,,} in
		y) break;;
		n) echo -e "Aborting...\n" && exit;;
		*) echo -e "Please retry... \n";;
	esac
done

echo -e "Okay. Running.\n"

echo
echo "sudo ddrescue -n $DISKNAME /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.img /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.log"
sudo ddrescue -n $DISKNAME /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.img /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.log
echo
echo "sudo ddrescue -r3 $DISKNAME /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.img /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.log"
sudo ddrescue -r3 $DISKNAME /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.img /mnt/Data/ClientBackups/DiskImages/$CLIENTNAME-$DATE.log
echo -e "\n\n-------------------------------------------------------------------------------\n"
echo -e "All Done!\n"
