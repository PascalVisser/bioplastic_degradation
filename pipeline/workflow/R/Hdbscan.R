args <- commandArgs(trailingOnly=TRUE)


#imports
library(dbscan)
library(dplyr)

suppressPackageStartupMessages({library(dplyr)})
suppressPackageStartupMessages({library(dbscan)})

path_files <- args[1]
file_list <- list.files(path=path_files, full.names = TRUE, pattern=".csv")


calc_log <- function (file_in){
  # Random samples data if file to big
    if (between(nrow(file_in), 10000, 20000)){
    file_in <- sample_n(file_in, 15000)
    memory.limit(size = 4000)
  } else if (nrow(file_in) > 20000){
    file_in <- sample_n(file_in, 25000)
    memory.limit(size = 4000)
  }

  modified <- file_in[1:2]

  modified[modified == 0.0] <- NA

  for(i in 1:ncol(modified)){
    modified[is.na(modified[,i]), i] <- mean(modified[,i], na.rm = TRUE)
  }

  return(log2(modified))
}




db_clustering <- function(file_in, NumOfPts = 20){

  log_file <- calc_log(file_in)
  scan <- hdbscan(x = log_file, minPts = NumOfPts, gen_hdbscan_tree = T, gen_simplified_tree = F)

  return(scan)
}

points_calc <- function(x){
  num_of_points <- length(x[,1])/100*1.5
  # if data is small, apply smaller number of points
  if (length(row(x[1])) > 1000){
    return(num_of_points)
  } else {
   return(15)}}
  
in_file <- read.csv(file_list)
log_file <- calc_log(in_file)
DBscan <- db_clustering(in_file, points_calc(in_file))
png(file="images/Hdbscan_output.png")
plot(log_file, col = DBscan$cluster +1, pch = 20)
dev.off()
