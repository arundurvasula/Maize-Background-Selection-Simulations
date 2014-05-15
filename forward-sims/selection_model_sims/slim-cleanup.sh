#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/selection_model_sims
#SBATCH -o /dev/null
#SBATCH -e /dev/null
# script to remove filed sims
set -e
if [ -f ./data/gamma_params.txt ] || [ -f ./data/stats.txt ]; then
    echo "gamma_params.txt or stats.txt already exist in the slurm-log directory. Please remove them."
    exit
fi

#Need to take care of files that are named: slim-stats.[JOBID].number
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
	cat './raw_data/gamma_params.'$JOBID$ITER'.txt' >> ./data/gamma_params.txt
	echo -e "\n" >> ./data/gamma_params.txt
    fi

done