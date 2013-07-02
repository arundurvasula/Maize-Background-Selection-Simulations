#$ -S /bin/bash
#$ -cwd
#$ -t 1-10
module load gcc libsequence &> /dev/null

Rscript generate_params.r $JOB_ID $SGE_TASK_ID > out.$JOB_ID.$SGE_TASK_ID
convertSFS_CODE out.$JOB_ID.$SGE_TASK_ID --ms | msstats > stats.$JOB_ID.$SGE_TASK_ID
