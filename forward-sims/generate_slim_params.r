#Script to create SLiM input files

#TODO: Generate stepwise linear expansion
pi_dist <- read.table("../pi_dist.txt")

newline <- "\n"
s_mut_type <- "#MUTATION TYPES\n"
s_mut_1 <- "m1"
n_m1_dom_coef <- 0.5
s_mut_fixed <- "f"
n_m1_select_coef <- 0.0

s_mut_rate <- "#MUTATION RATE\n"
n_ne <- 10000
n_final <- 100000
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

#after 10000 gens, from 10001-10171 add a number of ind every generation
n_children <- ceiling((n_final - n_ne) / (n_gens - n_burn_in))
for (i in n_burn_in:n_gens) {
  #stepwise linear expansion
  command <- paste(command, i, s_change_pop_size, s_pop_1, n_children, newline)
}

#add output line
command <- paste(command, s_out, n_out_time, s_sample, s_pop_1, n_out_size, s_ms, sep=" ")
cat(command, "\n", file="paramsFile.txt") #will need to pass task id variable
system("slim paramsFile.txt")
