#!/bin/bash
# script to remove filed sims
set -e
if [ -f ./slurm-log/bneck.txt ] || [ -f ./slurm-log/stats.txt ]; then
    echo "bneck.txt or stats.txt already exist in the slurm-log directory. Please remove them."
    exit
fi

FILES=(`find ./slurm-log/slim-pipeline-out* -type f`)
for file in ${FILES[@]}
do
    length=$(wc -l $file)
    parsed=$(echo $length | cut -f 1 -d ' ') # parse out actual number
    if [ "$parsed" == "2" ]; then
	#ugly parsing code. writes filename to stdout, extracts JOBID, removes .txt
	#example filename: slim-pipeline-out-12397-12841.txt -> result: 12841
	JOBID=$(echo $file | cut -f 6 -d '-' | cut -f 1 -d '.')
	cat $file >> ./slurm-log/stats.txt
	cat './slurm-log/bneck.'$JOBID'.txt' >> ./slurm-log/bneck.txt
    fi
done