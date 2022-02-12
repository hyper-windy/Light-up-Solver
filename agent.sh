#! /bin/bash

if [[ ! $# -eq 1 ]]
then
	echo Usage: $0 input-file
	exit 1
fi

head="${1%.*}"

./input_helper $1
swipl < run_${head}.pl > tracking.txt
./output_helper $1