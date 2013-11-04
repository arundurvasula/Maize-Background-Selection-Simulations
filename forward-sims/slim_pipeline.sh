#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/
#SBATCH -o /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/slurm-log/slim-pipeline-out-%A-%j.txt
#SBATCH -e /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/slurm-log/slim-pipeline-stderr-%A-%j.txt
#SBATCH -J slim-pipeline
set -e
set -u
module load libsequence

Rscript generate_slim_params.r $SLURM_JOB_ID | awk '/\/\// {seen = 1} seen {print}' | msstats