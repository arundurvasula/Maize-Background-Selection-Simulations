#$ -S /bin/bash
#$ -cwd
#$ -e /dev/null
#$ -o /dev/null
#$ -t 1-50000
module load gcc
module load libsequence

for i in {1..10}
do
    Rscript generate_params.r $JOB_ID $SGE_TASK_ID $i > out.$JOB_ID.$SGE_TASK_ID.$i
    convertSFS_CODE out.$JOB_ID.$SGE_TASK_ID.$i --ms | msstats > stats.$JOB_ID.$SGE_TASK_ID.$i
    rm out.$JOB_ID.$SGE_TASK_ID.$i
done
