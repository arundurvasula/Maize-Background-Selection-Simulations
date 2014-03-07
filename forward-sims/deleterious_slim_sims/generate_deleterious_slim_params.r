#Script to create SLiM input files with deleterious mutations
options(scipen=999)

args <- commandArgs(trailingOnly=TRUE)
JOB_ID <- strsplit(args, " ")[[1]]
ITER <- strsplit(args, " ")[[2]]
pi_dist <- read.table("../../pi_dist.txt") #NEED TO MOVE pi_dist!

newline <- "\n"
s_mut_type <- "#MUTATION TYPES\n"
s_mut_1 <- "m1"
n_m1_dom_coef <- 0.1
s_mut_gamma <- "g"
n_m1_mean <- -1 * runif(1,0,5e-6)
n_m1_shape <- runif(1,0,2) #deleterious (gamma DFE, h=0.1)
gamma_params_file <- paste("./raw_data/gamma_params.", JOB_ID, ITER, ".txt", sep="")
cat(n_m1_mean, "\t", n_m1_shape, "\t", file=gamma_params_file)

s_mut_2 <- "m2"
n_m2_dom_coef <- 0.5
s_mut_fixed <- "f"
n_m2_selection <- 0.0 # fixed

s_mut_rate <- "#MUTATION RATE\n"
n_ne <- 2e3
n_final <- 13333
n_mut_rate <- sample(pi_dist[[1]], 1, replace=TRUE) / (4*n_ne)

s_gen_el_type <- "#GENOMIC ELEMENT TYPES\n"
s_gen_el_1 <- "g1"
s_g1_mut_type <- "m1"
n_g1_m1_mut_prop <- 0.75
s_g1_mut_type_2 <- "m2"
n_g1_m2_mut_prop <- 0.25 #exon (75% del, 25% neutral)

s_gen_el_2 <- "g2"
s_g2_mut_type <- "m1"
n_g2_m1_mut_prop <- 0.5
s_g2_mut_type_2 <- "m2"
n_g2_m2_mut_prop <- 0.5 #UTR (50% del, 50% neutral)

s_gen_el_3 <- "g3"
s_g3_mut_type <- "m2"
n_g3_m2_mut_prop <- 1.0 #intron (100% netural)

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

command <- paste(s_mut_type, s_mut_1, n_m1_dom_coef, s_mut_gamma, n_m1_mean, n_m1_shape, newline,
                 s_mut_2, n_m2_dom_coef, s_mut_fixed, n_m2_selection, newline,
		 s_mut_rate, n_mut_rate, newline,
                 s_gen_el_type, s_gen_el_1, s_g1_mut_type, n_g1_m1_mut_prop, s_g1_mut_type_2, n_g1_m2_mut_prop, newline,
		 s_gen_el_2, s_g2_mut_type, n_g2_m1_mut_prop, s_g2_mut_type_2, n_g2_m2_mut_prop, newline,
		 s_gen_el_3, s_g3_mut_type, n_g3_m2_mut_prop, newline,
                 s_chr_org,s_gen_el_1, n_chr_start, n_chr_end, newline,
                 s_recomb_rate, n_chr_end, n_recomb, newline,
                 s_gens, n_gens, newline,
                 s_dem_struct, n_time_start, s_new_pop, s_pop_1, n_p1_size, newline)



#place bottleneck here after 10000 gens
post <- read.table("../data/posterior-dist-pi-tajd.txt", header=FALSE)
n_bneck_size <- sample(post$V1, 1)
n_bneck <- floor(n_ne * n_bneck_size)
#bneck_file <- paste("./slurm-log/bneck.", JOB_ID, ITER, ".txt", sep="")
#cat(n_bneck_size, "\n", file=bneck_file)
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
command <- paste(command, s_out, n_out_time, s_sample, s_pop_1, n_out_size, s_ms, newline)
paramsFile <- paste("./raw_data/paramsFile.", JOB_ID, ".", ITER, ".txt", sep="")
cat(command, "\n", file=paramsFile)  #will need to pass task id variable
system(paste("/home/adurvasu/slim/slim ", paramsFile, sep=""))
