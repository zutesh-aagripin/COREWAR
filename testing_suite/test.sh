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

get_problem()
{
	PROBLEM=$(( $PROBLEM ));
	printf "${RED} PROBLEM IN DETAIL ${NC}\n"
	./originals/corewar -d $PROBLEM -v 6$ARG testers/$CHAMPION > original;
	./to_test/corewar -dump $PROBLEM -v 6$ARG testers/$CHAMPION > our;
	THIS=$( echo "$PROBLEM" )
	cat original | grep -w "$THIS" -B 20 -A 5 > original1;
	cat our | grep -w "$THIS" -B 20 -A 5 > our1;
	printf "${RED} ______ORIGINAL______ ${NC}\n"
	cat original1;
	printf "${RED} ______OUR___________ ${NC}\n"
	cat our1;
}	
	
detail_check()
{
	CYCLES=$(( $CYCLES - 1000))
	printf "${RED} PROBLEM IN BETWEEN $CYCLES AND $PROBLEM ${NC}\n"
	echo "--- [DETAILED DIFF TEST] ---";
	while [ $CYCLES -lt $PROBLEM ];
	do
		./originals/corewar -d $CYCLES$ARG testers/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES$ARG testers/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 10));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
	fi;
	done;
	printf "${RED} PROBLEM ON CYCLE $PROBLEM ${NC}\n"
}

primary_check()
{
	while [ $CYCLES -lt "50000" ];
	do
		./originals/corewar -d $CYCLES$ARG testers/$CHAMPION > original;
		./to_test/corewar -dump $CYCLES$ARG testers/$CHAMPION > our;
		diff original our > file;
	WORDCOUNT=$(cat file | wc -l);
	if [ $WORDCOUNT = "0" ]
	then
		printf "${GREEN}▓${NC}";
		CYCLES=$(( $CYCLES + 1000));
	else
		printf "${RED}▓${NC}";
		PROBLEM=$CYCLES;
		return 
	fi;
	done;
}

find_champions()
{
	ls testers > lines
	grep .cor lines > champions
	CHAMPIONS=$( cat champions | wc -l )
}

analyze()
{
	CYCLES=0;
	PROBLEM=0;
	primary_check
	if [ $PROBLEM -eq "0" ]
	then
		printf "${GREEN} NO PROBLEM ${NC}\n"
	else
		detail_check
	fi;
}

find_champions

while [ $ORDER -lt $CHAMPIONS ];
do
	CHAMPION=$( sed -n "$ORDER"p champions)
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
	
