#!/bin/bash

echo "--- [ANALYSING COREWAR] ---";

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
UNDERLINE='\033[4m'
NC='\033[0m'

CYCLES=0;
PROBLEM=0;
CHAMPIONS=0;
ORDER=1;
FILE=$(echo $1)

initial_check()
{
	diff $FILE/$CHAMPION originalasm/$CHAMPION > file;
	diff $FILE/$CHAMPION originalasm/$CHAMPION >> asmtrace;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
	else
		PROBLEM=1;
	fi;
}

check_on_vm()
{
	PROBLEM=0;
	(./originals/corewar -v 31$ARG $FILE/$CHAMPION > our; ) & pid=$!
	( sleep 20 && pkill -HUP $pid ) 2>null & watcher=$!
	wait $pid 2>null;
	if ps -p $watcher 2>null;
	then
		pkill -HUP -P $watcher
		wait $watcher
	else
	    echo "your_code timeout"
		echo "timeout" >> our
	fi;
	(./originals/corewar -v 31$ARG originalasm/$CHAMPION > original; ) & pid=$!
	( sleep 20 && pkill -HUP $pid ) 2>null & watcher=$!
	wait $pid 2>null; 
	if ps -p $watcher 2>null;
	then
		pkill -HUP -P $watcher
		wait $watcher
	else
	    echo "original_code timeout"
		echo "timeout" >> original
	fi;
	diff original our > file;
	diff original our >> asmtrace;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
	else
		PROBLEM=1;
	fi;
}

encode()
{
	cp $FILE/$CHAMPION originalasm;
	./originals/asm originalasm/$CHAMPION;
	./to_test/asm $FILE/$CHAMPION;
}

find_s()
{
	ls $FILE > lines
	grep .s lines > champions
	CHAMPIONS=$( cat champions | wc -l; )
	CHAMPIONS=$(( $CHAMPIONS + 1));
}

find_champions()
{
	ls $FILE > lines
	grep .cor lines > champions
	CHAMPIONS=$( cat champions | wc -l; )
	CHAMPIONS=$(( $CHAMPIONS + 1));
}

analyze()
{
	CYCLES=0;
	PROBLEM=0;
	initial_check
	if [ $PROBLEM -eq "0" ]
	then
		check_on_vm
	else 
		printf "${RED} PROBLEM ${NC}\n"
		return ;
	fi;
	if [ $PROBLEM -eq "0" ]
	then
		printf "${GREEN} NO PROBLEM ${NC}\n"
	else 
		printf "${RED} PROBLEM ${NC}\n"
	fi;
}

echo $2
find_s
date > asmtrace

while [ $ORDER -lt $CHAMPIONS ];
do
	printf "${RED} Creating $CHAMPION ${NC}\n" >> asmtrace;
	CHAMPION=$( sed -n "$ORDER"p champions )
	echo $CHAMPION
		ARG=" ";
		encode
	ORDER=$(( $ORDER + 1));
done;

find_champions
ORDER=1;

while [ $ORDER -lt $CHAMPIONS ];
do
	printf "${RED} testing $CHAMPION ${NC}\n" >> asmtrace;
	CHAMPION=$( sed -n "$ORDER"p champions )
	echo $CHAMPION
		ARG=" ";
		echo "--- [PRIMARY DIFF TEST] ---";
		analyze
	ORDER=$(( $ORDER + 1));
done;
