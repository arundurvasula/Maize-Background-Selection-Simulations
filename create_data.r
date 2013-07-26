# grabs 10 samples  based on column and averages them
data <- read.table("temp_data_file.txt")
# data is two columns
stats1 <- sample(data[[1]], 10)
stats2 <- sample(data[[2]], 10)

cat(paste(mean(stats1),mean(stats2), sep = "\t"))
