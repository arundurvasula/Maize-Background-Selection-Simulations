# This script will take the parameters.txt and final_stats.txt and create a posterior that is graphable in R.
# uses ABCreg

# step 1: cut up parameters.txt to get the right parameters (in this case theta) 
cut -d " " -f 11 parameters.txt > temp_parameters.txt
# step 2: cut up final_stats.txt to get the right stats (in this case Pi and TajD)
cut -f 5,8 final_stats.txt > temp_sim_stats.txt
tail -n +2 "temp_sim_stats.txt" > temp_sim_stats2.txt
# step 3: combine these into the prior file
paste temp_parameters.txt temp_sim_stats2.txt > temp_prior_file.txt
grep -v "nan" < temp_prior_file.txt > prior_file.txt
# step 4: obtain data file

# step 5: use ABCreg
reg -T -P 1 -S 2 -p prior_file.txt -d data_file.txt -b bneck -t 0.01
# have a way to choose which stats to create data file from?
rm temp_*
