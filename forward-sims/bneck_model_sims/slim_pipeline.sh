#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/bneck_model_sims
#SBATCH -o /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/bneck_model_sims/out.txt
#SBATCH -e /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/bneck_model_sims/err.txt
#SBATCH -J slim-pipeline
#SBATCH --array=0-1000
#SBATCH -p serial
set -e
set -u
module load libsequence

for i in {0..100}
do
    Rscript generate_slim_params.r $SLURM_JOB_ID $i | awk '/\/\// {seen = 1} seen {print}' | msstats > ./raw_data/slim-stats.$SLURM_JOB_ID.$i
done
