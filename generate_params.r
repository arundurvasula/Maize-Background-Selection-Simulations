### Thoughts on initial sims to estimate bottleneck from noncoding regions:
## ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01 -t 0.01 -Td 0 0.8 -Tg 0 60 -TE 0.067 --length 1 10000 --annotate N
 
### Then add in selection:
## ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01(=theta) -t 0.01(draw) -Td 0 0.8(draw, model) -Tg 0 60(try several values) -TE 0.067 --length 1 10000 --annotate C --selDistType 2 0 blah blah 1 X(from some distr.)

### The below will have to be modified (ignore my comments below)

# Run with "Rscript generate_params.r $SGE_TASK_ID" 

SGE_TASK_ID <- commandArgs(trailingOnly=TRUE)

paramsFile <- file(paste("paramsFile.", SGE_TASK_ID, sep=""))
piFile <- file("pi_dist.txt")

# Variable naming convention:
# numbers start with "n_"
# strings start with "s_"
#
# each number that isn't a population or time should have a population ID and time ID
# Example: 
# type_flag_population_paramter

n_NPOP <- 1
n_ITER <- 1 #1 iteration per job? if fast enough, can do more but each needs own set of params
n_theta <- 0.01 #4*Ne*mu. will want to draw this from distribution based on data from Hufford et al. 2012
n_rho <- n_theta #same as theta for initial simulation
n_pop_0 <- 0 
n_pop_size <- 500
n_end_time <- 0.067
n_num_loci <- 1
n_length_loci <- 10000

n_Tg_0_time <- 0
n_Tg_0_alpha <- 2 #solve for this

n_Td_0_time <- 0
n_Td_0_pop_ratio <- 0.8

## sample sizes (one needed for each pop)
n_ss_0 <- 17 # to match 35 maize alleles in data

s_dom_event <- "-TD"
s_end_time <- "-TE"
s_spec_event <- "-TS"
s_exp_grow <- "-Tg"
s_rel_size_change <- "-Td"
s_theta <- "-t"
s_rho <- "-r"
s_pop <- "P" # pop number flag for growth etc.
s_sample_size <- "-n"
s_pop_size <- "--popSize"
s_loci <- "--length"
s_annotate <- "--annotate"
s_noncoding <- "N"

x <- paste("sfs_code", n_NPOP, n_ITER, s_sample_size, n_ss_0,s_pop_size, n_pop_size, s_rho, n_rho,  s_theta, n_theta, s_rel_size_change, n_Td_0_time, n_Td_0_pop_ratio, s_exp_grow, n_pop_0, s_pop, n_pop_0, n_Tg_0_alpha, s_loci, n_num_loci, n_length_loci, s_annotate, s_noncoding)

cat(x, "\n", file=paramsFile)

system(x)
