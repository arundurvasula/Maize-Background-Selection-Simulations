#x <- 'sfs_code 4 1 -Tg 0 P 0 2 -TD 2.5 0 1 0.01 300 -TD 2.5 0 2 0.05 250 -TD 2.5 0 3 0.02 400 -Tg 2.5 P 1 10 -Tg 2.5 P 2 15 -Tg 2.5 P 3 17 -TE 2.6'

### Thoughts on initial sims to estimate bottleneck from noncoding regions:
## ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01 -t 0.01 -Td 0 0.8 -Tg 0 60 -TE 0.067 --length 1 10000 --annotate N
 
### Then add in selection:
## ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01(=theta) -t 0.01(draw) -Td 0 0.8(draw, model) -Tg 0 60(try several values) -TE 0.067 --length 1 10000 --annotate C --selDistType 2 0 blah blah 1 X(from some distr.)

### The below will have to be modified (ignore my comments below)


# Run with "Rscript generate_params.r $SGE_TASK_ID" 

SGE_TASK_ID <- commandArgs(trailingOnly=TRUE)

paramsFile <- file(paste("paramsFile.", SGE_TASK_ID, sep=""))

# Variable naming convention:
# numbers start with "n_"
# strings start with "s_"
# distinguish between numbers and strings
# strings are parameter names
# numbers are parameter values
#
# each number that isn't a population or time should have a population ID and time ID
# Convention: 
# type_flag_population_paramter

n_NPOP <- 2 #two pops, maize and teosinte
n_ITER <- 1 #1 iteration per job? if fast enough, can do more but each needs own set of params
n_theta <- 0.01 #4*Ne*mu. will want to draw this from distribution based on data from Hufford et al. 2012
n_pop_0 <- 0 
n_pop_1 <- 1
n_pop_2 <- 2
n_pop_3 <- 3

n_Tg_0_time <- 0
n_Tg_0_alpha <- 2

n_TD_0_time <- 0
n_TD_0_allele_freq <- runif(1, 0.01, 0.05)
n_TD_0_size <- 300

n_TD_1_time <- 2.5
n_TD_1_allele_freq <- runif(1, 0.01, 0.05)
n_TD_1_size <- 200

## sample sizes (one needed for each pop)
n_ss_1 <- 7 # to match 14 teosinte alleles in data
n_ss_2 <- 17 # to match 35 maize alleles in data

s_dom_event <- "-TD"
s_end_time <- "-TE"
s_spec_event <- "-TS"
s_exp_grow <- "-Tg"
s_theta <- "-t"
s_pop <- "P" # pop number flag for growth etc.
s_sample_size <- "-n"

x <- paste("sfs_code", n_NPOP, n_ITER, s_sample_size, n_ss_1, n_ss_2, s_theta, n_theta, s_exp_grow, n_pop_0, s_pop, n_pop_0, n_Tg_0_alpha, s_dom_event, n_TD_0_time, n_pop_0, n_pop_1, n_TD_0_allele_freq, n_TD_0_size, s_dom_event, n_TD_1_time, n_pop_1, n_pop_2, n_TD_1_allele_freq, n_TD_1_size)

cat(x, "\n", file=paramsFile)

system(x)
