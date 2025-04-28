#!/bin/bash
#----- vars -----
HEADER=header.part
TOP=top.part
TROPHY=trophy.part
SEPARATOR=separator.part
BOTTOM=bottom.part
CONTINUE=true
SCREEN_NO=0
INFO=info.part
INPUT=

#----- methods -----
start () {
	> $TOP
	> $BOTTOM
}

next_screen () {
	SCREEN_NO=$(($SCREEN_NO+1))
	echo "Screen no $SCREEN_NO" > $TOP
	echo "Type letter: $INPUT" > $BOTTOM
	print
}

read_line () {
	read -e INPUT
}

read_key () {
	read -n 1 INPUT
}

check () {
	if [[ $INPUT == "q" ]];
	then
		CONTINUE=false
		echo "Zakończono grę." > $BOTTOM
		print
	elif ((SCREEN_NO >= 9));
	then
		CONTINUE=false
		echo "Remis!" > $BOTTOM
		print
	elif [[ $INPUT == "w" ]];
	then
		CONTINUE=false
		cat $TROPHY > $BOTTOM
		echo "Wygrał Tomek!" >> $BOTTOM
		print
	fi
}

print () {
	clear
	cat $HEADER $TOP $SEPARATOR $BOTTOM $SEPARATOR $INFO $SEPARATOR
}

#----- game -----
start
while [[ "$CONTINUE" == "true" ]]
do
	next_screen
	read_key
	check
done
