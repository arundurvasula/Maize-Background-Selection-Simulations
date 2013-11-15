###Purpose: 
To use approximate bayesian computation and a good rejection algorithm to create parameters that give summary statistics similar to the data found in Hufford et. al. 2012.

###Dependencies/Assumptions:
To run this full pipeline you need the following:

- The Sun Grid Engine
- Working executables of:
	- sfs_code
	- convertSFS_CODE
	- ms
	- msstats
	- ABCreg
	- R 
	- Python

If those executables are not already in your path, you must add them:

1. create a file called ".bash_profile" in your home directory (if it doesn't exist)

2. add this, substituting the paths to your exectuable:

		PATH=$PATH:/home/user/sfs_code/bin/:/home/user/msstats-0.3.1/bin/
		export PATH

###Forward Simulations:
This pipeline uses sfs_code to simulate maize domestication forward in time.

Directions to recreate simulations:

1. `source submit_million_forward.sh`
2. `source cleanup.sh`
3. `source create_posterior.sh`
4. 	Graph bneck.0.post in R
	
- You can test out those parameters with `Rscript generate_[simtype]_params.r 1 2 3`. The output will be on the terminal with parameters saved as 'paramsFile.1.2.3'

There is also a pipeline that uses slim to simulate maize domestication forward in time.

To use the slim pipeline:

1. Make sure the folder `slurm-log` exists in /forward-sims/

1. Run simulations: `source ./submit_multiple_slim_arrays.sh` 

	This script submits the slim_pipeline.sh script multiple times, as specified in the the for loop. After the simulations finish, the files will be placed in `slurm-log`. There are 4 types of output files:
	
	- bneck.[JOBID].txt => holds the size of the population after the bottleneck for the simulation
	- paramsFile.[JOBID].txt => holds the all of the parameters used for simulation
	- slim-pipeline-out.[ARRAYID].[JOBID].txt => holds one line of summary statistics for a population
	- slim-pipeline-stderr.[ARRAYID].[JOBID].txt => contains any error messages generated during simulation as well as anything else sent to sdterr.
	
2. Analysis: to run the analysis using ABCreg, you need a data file containing the mean of the summary staticstics and a prior file containing all of the simulated summary statistics. NOTE: file names and paths need to be changed.
	3. Create data file (uses Hufford statistics grabs the mean using awk):
					
			awk '{print($48,"\t",$37,"\t",$39, "\t",$40,"\t",$41,"\t",$42, "\t",$43, "\t")}' ~/sfs_code_workflow2/Hufford_et_al._2012_10kb_statistics/Hufford_et_al._2012_10kb_statistics.txt | grep -v "NA" | awk '{for(i=1; i<=NF; i++){sum[i]+=$i}} END {for(i=1; i<=NF; i++){printf sum[i]/NR "\t"}}' > data_file.txt
	
	4. Create prior file:
		1. Run slim-cleanup.sh to concatenate only valid stats and bottlenecks into one file.
		2. Remove stats labels from stats.txt
		
			`awk '$1 ~ /[0-9]/ {print}' semifinal_stats.txt > final_stats.txt`
		3. Grab only necessary stats:
			
			`awk '{print($1,"\t",$2,"\t",$4, "\t",$5,"\t",$6,"\t",$8, "\t",$13, "\t")}' final_stats.txt > temp_sim_stats.txt`
		
		4. Paste bottlenecks and sim stats together:
		
			`paste bneck temp_sim_stats | grep -v 'nan' > prior_file.txt`
		
	 5. Run ABCreg:
	 	
	 	 `~/ABCreg/reg -T -P 1 -S 7 -p prior_file.txt -d data_file.txt -b bneck -t 0.001`
	 	 
	 	 
###Coalescent Simulations:
This pipeline uses ms to simulate maize domestication backwards in time.
Directions to recreate simulations:

1. `Rscript gen_tbs.r`
2. `Rscript generate_ms_params.r`
3. `source ../create_posterior_ms.sh`
4. Graph bneck.0.post in R  

- Change parameters in `generate_[simtype]_params.r`


###"Oh man I can't believe I did that"

- The submit million scripts do a for loop twice that `qsub`s the sim script. The sim script submits an array job from 1-50,000 (max that SGE allows). Each job in the sim script has its own for loop that runs `generate_[simtype]_params.r` and the rest of the pipeline 10 times. So we have:
 	 		
 	 	2 array jobs x 50,000 jobs per array x 10 simulations per job = 1,000,000 simulations

====

Tricks for analysis

- data file contains summary stats from observed data. It should only be 1 line. (no headers):
	
		.0054 -0.434
(the stats above are Pi and TajD)

- prior file contains parameters and summary stats from the simulations. Each line should have the parameter value and the summary stats associated with it (no headers):

		0.835507987765595       65.7986 0.241462
		0.550444400170818       29.6863 -0.276919
		0.212850250769407       42.6132 0.212022
		0.781859162030742       106.241 -0.0995736
(the stats above are theta, Pi and TajD)

- make sure you're using the right data. If you're simulating with `--annotate N` then use stats from noncoding windows.
- make sure your stats are actually comparable: msstats gives theta pi per locus. Your data might have theta pi per base pair. 
- if your graph is crappy, try reducing the number of values in your posterior. 
- use `cut -f [column #]` to get a column of a file.
- stats currently being compared:
		
		sims        obs
		1-S*         48-S_rhoMZ
		2-n1*        37-singletonsMZ
		4-theta*     39-ThetaWMZ
		5-pi*        40-ThetaPiMZ
		6-thetaH*    41-ThetaHMZ
		8-tajd      42-TajDMZ
		13-rm       43-rmin
- Guide to final_stats (for reference when changing create_posterior.sh):
- 1 S
- 2 n1
- 3 next
- 4 theta
- 5 pi
- 6 thetaH
- 7 Hprime
- 8 tajd
- 9 fulif
- 10 fulid
- 11 fulifs
- 12 fulids
- 13 rm
- 14 rmmg
- 15 nhaps
- 16 hdiv
- 17 wallb
- 18 wallq
- 19 rosasrf
- 20 rosasru
- 21 zns