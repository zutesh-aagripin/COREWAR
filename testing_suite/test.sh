#!/bin/bash

echo "--- [ANALYSING COREWAR] ---";
echo "--- [PRIMARY DIFF TEST] ---";

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
CHAMPION=$1;

get_problem()
{
	printf "${RED} PROBLEM IN DETAIL ${NC}\n"
	./originals/corewar -d $PROBLEM -v 6 testers/$CHAMPION > original;
	./to_test/corewar -dump $PROBLEM -v 6 testers/$CHAMPION > our;
	THIS=$( echo "$PROBLEM" )
	cat original | grep -w "$THIS" -B 60 > original1;
	cat our | grep -w "$THIS" -B 60 > our1;
	printf "${RED} ______ORIGINAL______ ${NC}\n"
	cat original1;
	printf "${RED} ______OUR___________ ${NC}\n"
	cat our1;
}	
	
detail_check()
{
	CYCLES=$(( $CYCLES - 100))
	printf "${RED} PROBLEM IN BETWEEN $CYCLES AND $PROBLEM ${NC}\n"
	echo "--- [SECONDARY DIFF TEST] ---";
	while [ $CYCLES -lt $PROBLEM ];
	do
		./originals/corewar -d $CYCLES testers/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES testers/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 1 ));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
	fi;
	done;
	printf "${RED} PROBLEM ON CYCLE $PROBLEM ${NC}\n"
}

primary_check()
{
	while [ $CYCLES -lt "25000" ];
	do
		./originals/corewar -d $CYCLES testers/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES testers/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 100));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
		return 
	fi;
	done;
}

primary_check

if [ $PROBLEM -eq "0" ]
then
	printf "${GREEN} NO PROBLEM ${NC}\n"
else
	detail_check
	get_problem
fi;
