pi_dist <- read.table("../pi_dist.txt")
SIMULATIONS <- 10000

n_theta <- sample(pi_dist[[1]], SIMULATIONS, replace=TRUE) * 10000
n_rho <- n_theta #same as theta for initial simulation

n_final <- 10^6
n_initial <- 150000
n_Tg_0_time_const <- 0.0025
n_Td_0_pop_ratio <- runif(SIMULATIONS/100, 0, 1)
n_post_bneck <- n_Td_0_pop_ratio*n_initial # default value for alpha
n_alpha <- log(n_final/n_post_bneck)/(n_Tg_0_time_const)
for(i in 1:length(n_alpha)){ alpha_vec<-c(alpha_vec,rep(n_alpha[i], times=100))}
tbs <- data.frame(n_theta, n_rho, alpha_vec)
write.table(tbs, file="theta_rho_alpha.txt", row.names=FALSE, col.names=FALSE)