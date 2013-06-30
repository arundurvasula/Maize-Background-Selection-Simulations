#$ -S /bin/bash
#$ -cwd
#$ -t 1-10
module load gcc libsequence &> /dev/null

Rscript generate_params.r $SGE_TASK_ID > out.$SGE_TASK_ID
convertSFS_CODE out.$SGE_TASK_ID --ms | msstats > stats.$SGE_TASK_ID
