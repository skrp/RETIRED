#!/usr/local/bin/bash
# requires https://github.com/skrp/MKRX
##############################
# VULTL - chronic dump scraper
#    >++('>    ---skrp of MKRX
path_to_minion=${1%/}
# FUNCTIONS ##################
list () {
index=0
for minion in $path_to_minion/*
do
  TASKLIST[$index]=$minion;
  ((index++));
done
}
list () {
for minion in "${TASKLIST[@]}"
  grep 
}
task () {
path_to_minion="$1"
for i in "${TASKLIST[@]}"
do
  readlink -f "$path_to_minion"/"$i"/dump/* >> VULTL_init;
done
}
trans () {
while read -r line
do
  minion=${line%/}
  mv "$minion" dump/;
done < VULT_init
rm VULT_init;
} 
# ACTION  ##################
while true
do
	if [ -f VULTL_QUE ] 
	then
		list;
		task "$path_to_minion";
		sleep 43200;
		trans;
		d=$( date +%d%m_%H%M%S )
		XS "$path_to_minion""dump/" "$path_to_minion" || printf "%s failed\n" "$d" >> VULTL_log;
		# pool/ & g/ are the final dump dirs
	else
		sleep 3600;
	fi
done
