#Script to create SLiM input files

#TODO: Generate stepwise linear expansion
s_mut_type <- "#MUTATION TYPES\n"
s_mut_1 <- "m1"
n_m1_dom_coef <- 0.5
s_mut_fixed <- "f"
n_m1_select_coef <- 0.0

s_mut_rate <- "#MUTATION RATE\n"
n_ne <- 1.5e5
n_mut <- sample(pi_dist[[1]], 1, replace=TRUE) / 4*n_ne#divide pi_dist by 4*N_e. b/c per nucleotide

s_gen_el_type <- "#GENOMIC ELEMENT TYPES\n"
s_gen_el_1 <- "g1"
n_g1_mut_prop <- 1.0

s_chr_org <- "#CHROMOSOME ORGANIZATION\n"
n_chr_start <- 1
n_chr_end <- 1e4

s_recomb_rate <- "#RECOMBINATION RATE\n"
n_recomb <- 1e-7

s_gens <- "#GENERATIONS\n"
n_gens <- 1e-5

s_dem_struct <- "#DEMOGRAPHY AND STRUCTURE\n"
n_time_start <- 1
s_new_pop <- "P"
s_pop_1 <- "p1"
n_p1_size <- 1e4

s_out <- "#OUTPUT\n"
n_out_time <- n_gens
s_sample <- "R"
n_out_size <- 500
s_ms <- "MS"

command <- paste()
system(command)
