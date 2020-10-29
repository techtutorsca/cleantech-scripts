#!/bin/bash

### io.sh
###
### Input-related library for FAHT Scripts

pause_input () {
	read -n1 -s -r -p "Press any key to continue"
	echo -e "\n"
}

init_dialog () {
	
	FAHT_OPTONS="$(dialog --checklist --output-fd 1 "Check the options..." 20 50 40 \
	"quickmode" "Skip Memtest, LST, and ClamAV" "$FAHT_QUICKMODE" \
	"memtest" "Memory Test" "$FAHT_MEMTEST" \
	"shortonly" "Short SMART Test" "$FAHT_SHORTONLY" \
	"clamav" "Run ClamAV" "$FAHT_CLAMAV" \
	"diagmode" "Run diagnostics mode" "$FAHT_DAIGMODE" \
	"testonly" "Do not sync logfiles" "$FAHT_TESTONLY")"

	for $FAHT_OPTIONS; do
		if [ "$FAHT_OPTIONS" == "quickmode" ]; then
			FAHT_QUICKMODE=ON
		fi

		if [ "$FAHT_OPTIONS" == "memtest" ]; then
			FAHT_MEMTEST=ON
		fi

		if [ "$FAHT_OPTIONS" == "shortonly" ]; then
			FAHT_SHORTONLY=ON
		fi

		if [ "$FAHT_OPTIONS" == "clamav" ]; then
			FAHT_CLAMAV=ON
		fi

		if [ "$FAHT_OPTIONS" == "diagmode" ]; then
			FAHT_DIAGMODE=ON
		fi

		if [ "$FAHT_OPTIONS" == "testonly" ]; then
			FAHT_TESTONLY=ON
		fi
	done

}

### Usage confirm_prompt "Question string" $VARIABLE_TO_PUT_ANSWER_IN
confirm_prompt ()
{
	prompt_answer=
	while [ -z "$prompt_answer" ]; do
		if [ $2 ]
		then
			text_verify="You entered \e[1m$2\e[0m. "
		else
			text_verify=
		fi	
		echo -e "$text_verify$1 [Y/n] \c"

		read -n1 CONFIRM
		: ${CONFIRM:=y}
		echo
		
		case ${CONFIRM,,} in
			y|Y) prompt_answer=y;;
			n|N) prompt_answer=n;;
			*) echo -e "Please retry... \n";;
		esac
	done
}
### input_prompt usage: input_prompt "Question string" VARIABLE_NAME
### OR 
input_prompt ()
{
	INPUT=
	prompt_answer=
	if [ -z "$1" ]
	then
		echo "-Param #1 is zero-length"
	fi
	if [ -z "$2" ]
	then
		while [ -z "$prompt_answer" ]; do
			echo -e "$1 \c "
		confirm_prompt
	done
	else
		while [ "$prompt_answer" != "y" ]; do
		echo -e "$1 \c "
		read INPUT
		eval $2=$INPUT
		confirm_prompt "Is this correct?" $INPUT
	done
	fi

}

### Called without args
dialog_prompt ()
{
	INPUT=
	prompt_answer=
	if [ -z "$1" ]
	then
		echo "-Param #1 is zero-length"
	fi
	if [ -z "$2" ]
	then
		while [ -z "$prompt_answer" ]; do
			echo -e "$1 \c "
		confirm_prompt
	done
	else
		exec 3>&1
		INPUT="$(dialog --inputbox "$1" 0 0 2>&1 1>&3)"
		exec 3>&-
		eval "$2"=\"$(echo $INPUT)\"
	fi

}

### Called without args
break_program () {
	while true; do
		echo -e "Continue script? [Y/n]: \c "
		read -n1 CONTINUE_SCRIPT 
		echo -e "\n"
		: ${CONTINUE_SCRIPT:=y}

		case ${CONTINUE_SCRIPT,,} in
			y|Y) break;;
			n|N) exit;;
			*) echo -e "Please retry... \n";;
		esac
	done
}

### Get client information

client_details ()
{

	while [ "$prompt_answer" != "y" ]; do 
		dialog_prompt "First Name:" FAHT_FIRSTNAME
		dialog_prompt "Last Name:" FAHT_LASTNAME
		dialog_prompt "Problems Experienced:" FAHT_PROBLEMS

		clear
		echo "First Name: $FAHT_FIRSTNAME"
		echo "Last Name: $FAHT_LASTNAME"
		echo "Computer: $FAHT_COMP_DESC"
		echo "Problems Experienced: $FAHT_PROBLEMS"
		confirm_prompt "Is this correct?"

	done

	CONFIRM=
	FAHT_CLIENTNAME="$FAHT_LASTNAME-$FAHT_FIRSTNAME"
	FAHT_CLIENTDIR=/mnt/usbdata/faht-tests/"$FAHT_CLIENTNAME"
	FAHT_WORKINGDIR="$FAHT_CLIENTDIR"/"$FAHT_TEST_DATE"-"$FAHT_TEST_TIME"-"$FAHT_COMP_DESC"
	FAHT_WORKINGDIR=$(echo $FAHT_WORKINGDIR|sed 's/ //g'|sed 's/\.//g')

	#FAHT_TEMP="$(lshw -class system|grep product|sed -r 's/.*product: (.*) \(.*)/\1/'|sed 's/ /_/g'')"
	### Prep client folder ###
	if [ ! -d /mnt/usbdata/faht-tests ]; then
		mkdir /mnt/usbdata/faht-tests
		#chown "$FAHT_CURR_USER":"$FAHT_CURR_USER" /home/"$FAHT_CURR_USER"/fahttest;
	fi

	if [ ! -d "$FAHT_CLIENTDIR" ]; then
		mkdir "$FAHT_CLIENTDIR"
	fi

	if [ ! -d "$FAHT_WORKINGDIR" ]; then
		mkdir "$FAHT_WORKINGDIR"
		#chown "$FAHT_CURR_USER":"$FAHT_CURR_USER" "$FAHT_WORKINGDIR";
	fi

	cp /usr/share/faht/faht-report-template.fodt "$FAHT_WORKINGDIR"/faht-report.fodt
}
