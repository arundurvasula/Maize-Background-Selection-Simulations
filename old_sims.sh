#$ -S /bin/bash
#$ -N SFSrun
#$ -cwd
#$ -e /home/jri/projects/bigd/sim/logs/error.$JOB_ID.$TASK_ID
#$ -o /dev/null

temp=/state/partition1/jri/$JOB_ID
if [ ! -d "$temp" ]; then
	mkdir $temp
fi

#k=$SGE_TASK_ID
k=$JOB_ID
stype=$1

if [ $stype = "dom" ]; then
#domestication
sfs_code 3 10 -t 0.01 --popSize 5000 -TD 0 0 1 0.05 100 -Tg 0.0067 P 1 77 -TS 0.066 1 2 -TN 0.066 P 2 200 -Tg 0.066 P 2 3900 --neutPop 0 -TW 0 P 1 1 75 1 0 --neutPop 2 -TE 0.067 -o $temp/file.$k
fi;

if [ $stype = "imp" ]; then
#improvement
sfs_code 3 10 -t 0.01 --popSize 20000 --neutPop 0 --neutPop 1 -TD 0 0 1 0.05 400 -Tg 0.0067 P 1 77 -TS 0.066 1 2 -TN 0.066 P 2 800 -Tg 0.066 P 2 3900 -TW 0.066 P 2 1 400 1 0 -TE 0.067 -o $temp/file.$k;
fi;

if [ $stype = "neutral" ]; then
#neutral with constraint
#sfs_code 3 4 -t 0.01 -TD 0 0 1 0.05 10 -Tg 0.0067 P 1 77 -TS 0.066 1 2 -TN 0.066 P 2 10 -Tg 0.066 P 2 4650 -W 1 1 0 0.9 -TE 0.067 -o $temp/file.$k;
#neutral without constraint
sfs_code 3 10 -t 0.01 --popSize 5000 --neutPop 0 --neutPop 1 --neutPop 2 -TD 0 0 1 0.05 100 -Tg 0.0067 P 1 77 -TS 0.066 1 2 -TN 0.066 P 2 200 -Tg 0.066 P 2 3900 -TE 0.067 -o $temp/file.$k;
fi;

if [ $stype = "over" ]; then
#overlap
sfs_code 3 10 -t 0.01 --popSize 20000 -TD 0 0 1 0.05 400 -Tg 0.0067 P 1 77 -TS 0.066 1 2 -TN 0.066 P 2 800 -Tg 0.066 P 2 3900 --neutPop 0 -TW 0 P 1 1 75 1 0  -TW 0.066 P 2 1 400 1 0  -TE 0.067 -o $temp/file.$k
fi;

convertSFS_CODE $temp/file.$k --ms | msstats -I 3 12 12 12 > $temp/statsfile.$k

mv $temp/statsfile.$k ./$stype
rm $temp/file.$k
