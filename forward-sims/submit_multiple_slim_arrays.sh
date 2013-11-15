# run this to submit multiple job arrays
# slurm only allows job arrays of n=1000
for i in {0..1000}
do
	sbatch --array=0-1000 -p serial slim_pipeline.sh
	sleep(2)
done