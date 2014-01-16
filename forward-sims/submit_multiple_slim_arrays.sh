#!/bin/bash
# run this to submit multiple job arrays
# slurm only allows job arrays of n=1000
#set -e

#cd /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/

#jqlen=$(squeue -u adurvasu | wc -l) #check how many jobs I'm running
#totsimsrun=$(cat ./simsrun.txt)
#totalsims=1000000

#if [ $totsimsrun -lt $totalsims ]; then
#    if [ $jqlen = 1 ]; then
        #echo "no jobs running"
#        sbatch slim_pipeline.sh
#	echo "$(($totsimsrun + 1000))" > ./simsrun.txt
#    fi
#fi

for i in {0..10}
do
    sbatch slim_pipeline.sh
done
