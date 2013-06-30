#x <- 'sfs_code 4 1 -Tg 0 P 0 2 -TD 2.5 0 1 0.01 300 -TD 2.5 0 2 0.05 250 -TD 2.5 0 3 0.02 400 -Tg 2.5 P 1 10 -Tg 2.5 P 2 15 -Tg 2.5 P 3 17 -TE 2.6'

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

n_NPOP <- 3
n_ITER <- 1
n_theta <- 0.001
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

s_dom_event <- "-TD"
s_end_time <- "-TE"
s_spec_event <- "-TS"
s_exp_grow <- "-Tg"
s_theta <- "-t"
s_pop <- "P"

x <- paste("sfs_code", n_NPOP, n_ITER, s_theta, n_theta, s_exp_grow, n_pop_0, s_pop, n_pop_0, n_Tg_0_alpha, s_dom_event, n_TD_0_time, n_pop_0, n_pop_1, n_TD_0_allele_freq, n_TD_0_size, s_dom_event, n_TD_1_time, n_pop_1, n_pop_2, n_TD_1_allele_freq, n_TD_1_size)

cat(x, "\n", file=paramsFile)

system(x)
