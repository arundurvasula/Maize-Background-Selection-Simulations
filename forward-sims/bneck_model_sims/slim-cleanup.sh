#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/bneck_model_sims/
#SBATCH -o /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/bneck_model_sims/slim-cleanup-out-%j.txt
#SBATCH -e /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/bneck_model_sims/slim-cleanup-err-%j.txt 
# script to remove filed sims
set -e
if [ -f ./data/stats.txt ]; then
    echo "stats.txt already exists in the data directory. Please remove them."
    exit
fi

#Takes care of files with slim-pipeline-out* naming
#FILES=(`find ./data/slim-pipeline-out* -type f`)
#for file in ${FILES[@]}
#do
#    length=$(wc -l $file)
#    parsed=$(echo $length | cut -f 1 -d ' ') # parse out actual number
#    if [ "$parsed" == "2" ]; then
#	#ugly parsing code. writes filename to stdout, extracts JOBID, removes .txt
#	#example filename: slim-pipeline-out-12397-12841.txt -> result: 12841
#	JOBID=$(echo $file | cut -f 6 -d '-' | cut -f 1 -d '.')
#	cat $file >> ./slurm-log/stats.txt
#	cat './slurm-log/bneck.'$JOBID'.txt' >> ./slurm-log/bneck.txt
#    fi
#done

#Need to take care of files that are named: slim-stats.[JOBID].number
# Bnecks are named:bneck.[jobid][iteration].txt
FILES2=(`find ./raw_data/slim-stats* -type f`)
for file2 in ${FILES2[@]}
do
    #grab job id and iteration slim-stats.58150.100
    length=$(wc -l $file2)
    parsed=$(echo $length | cut -f 1 -d ' ')
    if [ "$parsed" == "2" ]; then
	JOBID=$(echo $file2 | cut -f 3 -d ".")
	ITER=$(echo $file2 | cut -f 4 -d ".")
	cat $file2 >> ./data/stats.txt
#	cat './data/bneck.'$JOBID$ITER'.txt' >> ./data/bneck.txt
    fi

done