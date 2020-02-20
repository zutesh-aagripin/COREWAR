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

get_problem()
{
	PROBLEM=$(( $PROBLEM + 2));
	printf "${RED} PROBLEM ON CYCLE ${NC}\n" >> trace;
	./originals/corewar -a -d $PROBLEM -v 6$ARG $FILE/$CHAMPION > original;
	./to_test/corewar -dump $PROBLEM -v 6$ARG $FILE/$CHAMPION > our;
#	THIS=$( echo "$PROBLEM" )
#	cat original | grep -w "$THIS" -B 15 -A 100 > original1;
#	cat our | grep -w "$THIS" -B 15 -A 100 > our1;
#	printf "${RED} ______ORIGINAL______ ${NC}\n" >> trace;
#	cat original1 >> trace;
#	printf "${RED} ______OUR___________ ${NC}\n" >> trace;
#	cat our1 >> trace;
	diff original our >> trace;
}	
	
thorough_check()
{
	CYCLES=$(( $CYCLES - 100))
	printf "${RED} PROBLEM IN BETWEEN $CYCLES AND $PROBLEM ${NC}\n"
	echo "--- [HIGH DETAIL DIFF TEST] ---";
	while [ $CYCLES -lt $PROBLEM ];
	do
		./originals/corewar -a -d $CYCLES$ARG $FILE/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES$ARG $FILE/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 1));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
	fi;
	done;
	printf "${RED} PROBLEM ON CYCLE $PROBLEM ${NC}\n"
	
}

detail_check()
{
	CYCLES=$(( $CYCLES - 2500))
	printf "${RED} PROBLEM IN BETWEEN $CYCLES AND $PROBLEM ${NC}\n"
	while [ $CYCLES -lt $PROBLEM ];
	do
		./originals/corewar -a -d $CYCLES $ARG $FILE/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES$ARG $FILE/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 100));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
	fi;
	done;
}

primary_check()
{
	echo "--- [DETAILED DIFF TEST] ---";
	PROBLEM=0;
	while [ $CYCLES -lt "50000" ];
	do
		./originals/corewar -d $CYCLES $ARG $FILE/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES $ARG $FILE/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 2500));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
		return 
	fi;
	done;
}

initial_check()
{
	printf "${RED} testing $CHAMPION with $ARG ${NC}\n" >> trace;
	set -x;
	./originals/corewar -a -v 15$ARG $FILE/$CHAMPION > original;
	./to_test/corewar -v 15$ARG $FILE/$CHAMPION > our;

	diff original our > file;
	diff original our >> trace;
	WORDCOUNT=$(cat file | wc -l);
	set +x;
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
	else
		PROBLEM=1;
	fi;
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
		printf "${GREEN} NO PROBLEM ${NC}\n"
	else 
	printf "${RED} PROBLEM ${NC}\n"
		primary_check
		if [ $CYCLES = "50000" ]
		then
			printf "${GREEN} ACTUALLY, PROBLEMS IN VERBOSITY :) $PROBLEM ${NC}\n"
		else
			detail_check
			thorough_check
		fi;
	fi;
}

echo $2
find_champions
date > trace

while [ $ORDER -lt $CHAMPIONS ];
do
	CHAMPION=$( sed -n "$ORDER"p champions )
	echo $CHAMPION
	ARG=" ";
	echo "--- [PRIMARY DIFF TEST] ---";
	analyze
	ARG=" testers/jumper.cor";
	echo "--- [SECONDARY DIFF TEST] ---";
	analyze
	ARG=" testers/jumper.cor testers/jumper.cor";
	echo "--- [TRIARY DIFF TEST] ---";
	analyze
	ARG=" testers/jumper.cor testers/jumper.cor testers/jumper.cor";
	echo "--- [TERTIATY DIFF TEST] ---";
	analyze
	ORDER=$(( $ORDER + 1));
done;
