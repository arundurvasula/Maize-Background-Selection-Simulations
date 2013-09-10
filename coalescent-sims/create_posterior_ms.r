# SOI: stats.txt: 1 2 4 5 6 8 13
# SOI Huff_2012.txt: 48 37 39 40 41 42 43
# 1 sim = 100 lines of stats
# get mean + variance for all stats of interest (SOI) for each sim > prior_file.txt

## Functions
colSd <- function(x, na.rm=TRUE) { 
#from http://stackoverflow.com/questions/17549762/is-there-such-colsd-in-r
# colSd not in stdlib
  if (na.rm) {
    n <- colSums(!is.na(x)) # thanks @flodel
  } else {
    n <- nrow(x)
  }
  colVar <- colMeans(x*x, na.rm=na.rm) - (colMeans(x, na.rm=na.rm))^2
  return(sqrt(colVar * n/(n-1)))
}

## Script
parameters.file <- read.table("theta_rho_alpha2.txt")
sim.file <- read.table("./stats.txt", header=TRUE)
sim <- data.frame(sim.file$S, sim.file$n1, sim.file$theta, sim.file$pi, sim.file$thetaH, sim.file$tajd, sim.file$rm)
END <- nrow(sim)
for (i in 1:END) {
  if(i == 1) {
    sim.means <- colMeans(sim[1:100,1:7], na.rm=TRUE)
    sim.sd <- colSd(sim[1:100,1:7], na.rm=TRUE)
  }
  else if (i %% 100 == 0) {
    if(!(i>9900)) {
    sim.means <- rbind(sim.means, colMeans(sim[(i+1):(i+100),1:7], na.rm=TRUE))
    sim.sd <- rbind(sim.sd, colSd(sim[(i+1):(i+100),1:7], na.rm=TRUE))
    }
  }
}

sim.stats <- data.frame(unique(parameters.file$V3),sim.means,sim.sd)

write.table(sim.stats, file="./prior_file.txt", sep = "\t", eol = "\n", row.names=FALSE, col.names=FALSE)


#get mean + variance for all SOI in Huff_2012 > data_file.txt
#huff.data <- read.table("../Hufford_et_al._2012_10kb_statistics.txt", header=TRUE)
#huff <- data.frame(huff.data$S_rhoMZ, huff.data$SingletonsMZ, huff.data$ThetaWMZ, huff.data$ThetaPiMZ, huff.data$ThetaHMZ, huff.data$TajDMZ, huff.data$RminMZ)

#huff.means <- colMeans(huff, na.rm=TRUE)
#huff.sd <- colSd(huff, na.rm=TRUE)

#huff.stats <- data.frame(huff.means,huff.sd)
#write.table(huff.stats, file="./data_file.txt", sep = "\t", eol = "\t", row.names=FALSE, col.names=FALSE)

reg <- "~/Documents/Science/software/reg -T -P 1 -S 14 -p ./prior_file.txt -d ./data_file.txt -b bneck -t 0.1"
system(reg)