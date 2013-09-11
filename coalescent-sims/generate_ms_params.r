### Thoughts on initial sims to estimate bottleneck from noncoding regions:
## ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01 -t 0.01 -Td 0 0.8 -Tg 0 60 -TE 0.067 --length 1 10000 --annotate N
 
### Then add in selection:
## ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01(=theta) -t 0.01(draw) -Td 0 0.8(draw, model) -Tg 0 60(try several values) -TE 0.067 --length 1 10000 --annotate C --selDistType 2 0 blah blah 1 X(from some distr.)

### The below will have to be modified (ignore my comments below)

# Not meant for parallelizing on farm. Using "tbs" won't allow it. 

#args <- commandArgs(trailingOnly=TRUE)
#JOB_ID <- strsplit(args, " ")[[1]]
#SGE_TASK_ID <- strsplit(args, " ")[[2]]
#i <- strsplit(args, " ")[[3]]
#paramsFile <- file(paste("paramsFile.", JOB_ID,".", SGE_TASK_ID, ".", i, sep=""))
#pi_dist <- read.table("../pi_dist.txt")

# Variable naming convention:
# numbers start with "n_"
# strings start with "s_"
#
# each number that isn't a population or time should have a population ID and time ID
# Example: 
# type_flag_population_paramter
options("scipen"=100, "digits"=4)
n_sam <- 17
n_reps <- 1000000 #should match number of SIMULATIONS in gen_tbs.r and samples in theta_rho_alpha.txt
n_sites <- 10000
n_growth_rates_alpha <- 0.0025
n_growth_rates_time <- 0
n_subpop_size_time <- 0.0025
n_subpop_size_x <- 0.15

#n_theta <- sample(pi_dist[[1]], SIMULATIONS) * 10000
#n_rho <- n_theta #same as theta for initial simulation
#n_final <- 10^6
#n_initial <- 150000
#n_Tg_0_time_const <- 0.03333333
#n_Td_0_pop_ratio <- runif(SIMULATIONS, 0, 1)
#n_post_bneck <- n_Td_0_pop_ratio[1]*n_initial # default value for alpha
#n_alpha <- log(n_final/n_post_bneck)/(n_Tg_0_time_const)
#curr_bneck <- n_Td_0_pop_ratio[1]
#n_pop_0 <- 0 
#n_pop_size <- 500
#n_end_time <- 0.033
#n_num_loci <- 100
#n_length_loci <- 10000
#n_linkage <- -1 #unlinked
#n_ITER <- 1 #1 iteration per job? if fast enough, can do more but each needs own set of params
#n_Tg_0_time <- 0
#n_Td_0_time <- 0
## sample sizes (one needed for each pop)
#n_ss_0 <- 17 # to match 35 maize alleles in data

s_growth_rates <- "-eG"
s_subpop_size <- "-eN"
s_alpha <- "-G"
s_theta <- "-t"
s_rho <- "-r"
s_tbs <- "tbs"

#s_dom_event <- "-TD"
#s_end_time <- "-TE"
#s_spec_event <- "-TS"
#s_exp_grow <- "-Tg"
#s_rel_size_change <- "-Td"
#s_pop <- "P" # pop number flag for growth etc.
#s_sample_size <- "-n"
#s_pop_size <- "--popSize"
#s_loci <- "--length"
#s_linkage <- "--linkage"
#s_linkage_physical <- "p"
#s_annotate <- "--annotate"
#s_noncoding <- "N"

# sort the theta_rho_alpha file so we can get mean and variance for each sim
system("sort -k 3 < theta_rho_alpha.txt > theta_rho_alpha2.txt")
x <- paste("ms ", n_sam, n_reps, s_theta, s_tbs, s_rho, s_tbs, n_sites, s_alpha, s_tbs, s_growth_rates, n_growth_rates_alpha, n_growth_rates_time, s_subpop_size, n_subpop_size_time, n_subpop_size_x, "<theta_rho_alpha2.txt | ~/Documents/Science/software/msstats > stats.txt")
cat(x, "\n", file="./paramsFile.txt")
system(x)

