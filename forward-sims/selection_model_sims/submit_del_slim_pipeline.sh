#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/selection_model_sims/
#SBATCH -o /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/selection_model_sims/out.$SLURM_JOB_ID
#SBATCH -e /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/selection_model_sims/err.$SLURM_JOB_ID
#SBATCH -J slim-pipeline
#SBATCH --array=0-10
#SBATCH -p serial
set -e
set -u
module load libsequence

for i in {0..1}
do
    Rscript generate_deleterious_slim_params.r $SLURM_JOB_ID $i | awk '/\/\// {seen = 1} seen {print}' | msstats > ./raw_data/slim-stats.$SLURM_JOB_ID.$i
done
