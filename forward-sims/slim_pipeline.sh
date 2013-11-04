#!/bin/bash
#SBATCH -D /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/
#SBATCH -o /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/slurm-log/slim-pipeline-out-%j.txt
#SBATCH -e /home/adurvasu/Maize-Background-Selection-Simulations/forward-sims/slurm-log/slim-pipeline-stderr-%j.txt
#SBATCH -J slim-pipeline
set -e
set -u
module load gcc
module load libsequence

Rscript generate_slim_params.r %A | awk '/\/\// {seen = 1} seen {print}' | msstats