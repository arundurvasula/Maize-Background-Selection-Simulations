ARG_MAX="-n131072" #system wide max # of args. 

find . -name "paramsFile.*" | xargs $ARG_MAX cat > parameters.txt
find . -name "paramsFile.*" | xargs $ARG_MAX mv -t /home/adurvasu/trash/

find . -name "stats.*" | xargs $ARG_MAX cat > semifinal_stats.txt
find . -name "stats.*" | xargs $ARG_MAX mv -t /home/adurvasu/trash/

module load python
python clean_stats.py
mv semifinal_stats.txt /home/adurvasu/trash
