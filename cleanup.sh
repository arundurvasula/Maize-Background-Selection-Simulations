ARG_MAX="-n131072" #system wide max # of args. 

find . -name "paramsFile.*" | sort | xargs $ARG_MAX cat > parameters.txt
#find . -name "paramsFile.*" | xargs $ARG_MAX mv -t /home/adurvasu/trash/

find . -name "stats.*" | sort | xargs $ARG_MAX cat > semifinal_stats.txt
#find . -name "stats.*" | xargs $ARG_MAX mv -t /home/adurvasu/trash/

#only print if the first field has a number; keep header
#awk 'FNR ~ 1 {print} $1 ~ /[0-9]/ {print}' semifinal_stats.txt > final_stats.txt
awk '$1 ~ /[0-9]/ {print}' semifinal_stats.txt > final_stats.txt
#module load python
#python clean_stats.py
#mv semifinal_stats.txt /home/adurvasu/trash
