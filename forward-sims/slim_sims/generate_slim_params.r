#Script to create SLiM input files

args <- commandArgs(trailingOnly=TRUE)
JOB_ID <- strsplit(args, " ")[[1]]
ITER <- strsplit(args, " ")[[2]]
pi_dist <- read.table("../pi_dist.txt")

newline <- "\n"
s_mut_type <- "#MUTATION TYPES\n"
s_mut_1 <- "m1"
n_m1_dom_coef <- 0.5
s_mut_fixed <- "f"
n_m1_select_coef <- 0.0

s_mut_rate <- "#MUTATION RATE\n"
n_ne <- 2e3
n_final <- 13333
n_mut <- sample(pi_dist[[1]], 1, replace=TRUE) / (4*n_ne)#divide pi_dist by 4*N_e. b/c per nucleotide

s_gen_el_type <- "#GENOMIC ELEMENT TYPES\n"
s_gen_el_1 <- "g1"
n_g1_mut_prop <- 1.0

s_chr_org <- "#CHROMOSOME ORGANIZATION\n"
n_chr_start <- 1
n_chr_end <- 1e4

s_recomb_rate <- "#RECOMBINATION RATE\n"
n_recomb <- 1e-7

s_gens <- "#GENERATIONS\n"
n_burn_in <- 10000
n_gens <- 10171

s_dem_struct <- "#DEMOGRAPHY AND STRUCTURE\n"
n_time_start <- 1
s_new_pop <- "P"
s_pop_1 <- "p1"
n_p1_size <- n_ne
s_change_pop_size <- "N"

s_out <- "#OUTPUT\n"
n_out_time <- n_gens
s_sample <- "R"
n_out_size <- 500
s_ms <- "MS"

command <- paste(s_mut_type, s_mut_1, n_m1_dom_coef, s_mut_fixed, n_m1_select_coef, newline,
                 s_mut_rate, n_mut, newline,
                 s_gen_el_type, s_gen_el_1, s_mut_1, n_g1_mut_prop, newline,
                 s_chr_org, s_gen_el_1, n_chr_start, n_chr_end, newline,
                 s_recomb_rate, n_chr_end, n_recomb, newline,
                 s_gens, n_gens, newline,
                 s_dem_struct, n_time_start, s_new_pop, s_pop_1, n_p1_size, newline)



#place bottleneck here after 10000 gens
runif_greater_than_0 <- function (n, min, max) {
  results <- runif(n, min, max)
  if (min == max ) {
    return(min)
  }
  if (results > 0) {
    return(results)
  }
  else if (results == 0) {
    runif_greater_than_0(n, min, max)
  }
  
}
n_bneck_size <- runif_greater_than_0(1, 0, 1)
n_bneck <- floor(n_ne * n_bneck_size)
bneck_file <- paste("./slurm-log/bneck.", JOB_ID, ITER, ".txt", sep="")
cat(n_bneck_size, "\n", file=bneck_file)
#after 10000 gens, from 10001-10171 add a number of ind every generation

## Exponential growth
k <- (log(n_final/n_bneck))/(n_gens - n_burn_in) 
gens <- (n_burn_in - n_burn_in):(n_gens - n_burn_in)
growth_function <- function(t) n_bneck*exp(k*t)
n_new <- floor(sapply(gens, growth_function))
## End exponential growth

## Linear growth / not being used
#n_children <- floor((n_final - n_ne) / (n_gens - n_burn_in))
#growth_function <- function (x) n_children*x
#n_new <- sapply((n_bneck/n_children):(n_final/n_children), growth_function)
## End linear growth

n_growth_gens <- n_burn_in:n_gens

for (i in 1:length(n_growth_gens)) {
  #stepwise linear expansion
  command <- paste(command, n_growth_gens[i], s_change_pop_size, s_pop_1, n_new[i], newline)
}

#add output line
command <- paste(command, s_out, n_out_time, s_sample, s_pop_1, n_out_size, s_ms)
paramsFile <- paste("./slurm-log/paramsFile.", JOB_ID, ITER, ".txt", sep="")
cat(command, "\n", file=paramsFile)  #will need to pass task id variable
system(paste("/home/adurvasu/slim/slim ", paramsFile, sep=""))
