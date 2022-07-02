args <- commandArgs(trailingOnly=TRUE)


#imports
.libPaths("./Rfiles_library/Rlibrary")


suppressPackageStartupMessages({library(dplyr)})
suppressPackageStartupMessages({library(dbscan)})






db_clustering <- function(file_in, NumOfPts = 20, file_name){


  # Random samples data if file to big
    if (between(nrow(file_in), 10000, 20000)){
    file_in <- sample_n(file_in, 15000, replace = T)
    memory.limit(size = 16000)
  } else if (nrow(file_in) > 20000){
    file_in <- sample_n(file_in, 28000, replace = T)
    memory.limit(size = 16000)
  }

  # strip all columns except fsc and ssc
  modified <- file_in[,c(1,2)]

  # if there are NA's, replaces them with the mean
  modified[modified == 0] <- NA

  for(i in 1:ncol(modified)){
    modified[is.na(modified[,i]), i] <- mean(modified[,i], na.rm = TRUE)
  }

  # log transform file
  log_file <- log2(modified)

  # Apply Hdbscan on log transformed data
  scan <- hdbscan(log_file, NumOfPts)

  # plots the data and return scan statistics
  plot(log_file, col = scan$cluster +1, pch = 20, main=file_name)
  return(scan)
}

points_calc <- function(x){

  # calculate number of points with 1.5%
  num_of_points <- length(x[,1])/100*1.5

  # if data is small, apply smaller number of points
  if (length(row(x[1])) > 20000){
    num_of_points <- 25000/100*0.55}
  else if (length(row(x[1])) < 1000){
    num_of_points <- 15}
  else {
  }

  return(num_of_points)
}






for (path in args){
  path <- gsub("\\[|,|\\]", "" ,path)
  full_path <- list.files(path = paste0(path,"/csv"), pattern = "map[0-9]+.csv", full.names = TRUE)
  in_file <- read.csv(full_path)
  csv_name <- basename(full_path)
  file_name <- tools::file_path_sans_ext(csv_name)
  png(file=paste0("images/",file_name,".png"))
  db_clustering(in_file, points_calc(in_file), file_name)
  dev.off()
  gc()
}

