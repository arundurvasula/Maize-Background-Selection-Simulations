#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/deleterious_slim_sims/
#SBATCH -o /dev/null
#SBATCH -e /dev/null
#SBATCH -J slim-pipeline
#SBATCH --array=0-1000
#SBATCH -p serial
set -e
set -u
module load libsequence

for i in {0..100}
do
    Rscript generate_deleterious_slim_params.r $SLURM_JOB_ID $i | awk '/\/\// {seen = 1} seen {print}' | msstats > ./raw_data/slim-stats.$SLURM_JOB_ID.$i
done
