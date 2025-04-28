#!/bin/bash
SAVE_X_FILE=x.save
SAVE_O_FILE=o.save
NEW_MATRIX_FILE=new.matrix
MATRIX_FILE=matrix
WIN_CONDITIONS_FILE=winconditions
X_SIGN="${1:-X}"
O_SIGN="${2:-O}"
TROPHY_FILE=trophy.ascii

header () {
	clear
	echo "==========================="
	echo "=== Circle & Cross game ==="
	echo "==========================="
	echo
	cat $MATRIX_FILE
	echo
}

print_state () {
	local file=$1
	local sign=$2
	local output=$3
	cat $file | cut -c1 |
	while read -r move;
	do
		sed -i.bak "s/$move/$sign/" $output
	done
	rm $output.bak
}

new_game () {
	cp "$NEW_MATRIX_FILE" "$MATRIX_FILE"
	> $SAVE_X_FILE
	> $SAVE_O_FILE
	header
}

move () {
	local turn=$1
	header
	echo "== Turn $turn =="
	if [ $[$turn % 2] -eq 1 ]
	then
		echo "Select $X_SIGN"
		read -n1 select
		echo "$select" >> $SAVE_X_FILE
		print_state $SAVE_X_FILE $X_SIGN $MATRIX_FILE
	else
		echo "Select $O_SIGN"
                read -n1 select
                echo "$select" >> $SAVE_O_FILE
		print_state $SAVE_O_FILE $O_SIGN $MATRIX_FILE
	fi
}

sort_moves () {
	local file=$1
	sort $file | paste -s -d ""
}

check () {
	cat $WIN_CONDITIONS_FILE | while read condition
	do
		if [[ $(sort_moves $SAVE_X_FILE) =~ $condition ]];
		then
			echo "$X_SIGN"
		elif [[ $(sort_moves $SAVE_O_FILE) =~ $condition ]];
		then
			echo "$X_SIGN"
		fi
	done
}

#------------------------------------------------
new_game
for i in {1..9}
do
  	move $i
	WINNER=$(check)
	echo "winner: $WINNER"
	if [[ $i -gt 4 ]] && [[ -n $WINNER ]];
	then
		header
		cat $TROPHY_FILE
		echo "    $WINNER won!"
		break
	fi
done
if [[ -z $WINNER ]];
then
	header
    echo "Draw!"
fi
