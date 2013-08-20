#$ -S /bin/bash
#$ -cwd
#$ -e /dev/null
#$ -o /dev/null
#$ -t 3301-10000
module load gcc
module load libsequence

if [ ! -d "/scratch/adurvasu/" ]; then
     mkdir /scratch/adurvasu/
fi

if [ ! -d "/scratch/adurvasu/maize_bs/" ]; then
    mkdir /scratch/adurvasu/maize_bs/
fi


for i in {1..10}
do
    Rscript generate_params.r $JOB_ID $SGE_TASK_ID $i > /scratch/adurvasu/maize_bs/out.$JOB_ID.$SGE_TASK_ID.$i
    convertSFS_CODE /scratch/adurvasu/maize_bs/out.$JOB_ID.$SGE_TASK_ID.$i --ms | msstats > /scratch/adurvasu/maize_bs/stats.$JOB_ID.$SGE_TASK_ID.$i
    #rm out.$JOB_ID.$SGE_TASK_ID.$i
    mv /scratch/adurvasu/maize_bs/out.$JOB_ID.$SGE_TASK_ID.$i /home/adurvasu/sfs_code_workflow
    mv /scratch/adurvasu/maize_bs/stats.$JOB_ID.$SGE_TASK_ID.$i /home/adurvasu/sfs_code_workflow
done
