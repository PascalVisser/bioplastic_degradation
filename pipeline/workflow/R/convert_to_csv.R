args = commandArgs(trailingOnly=TRUE)

#in_file <- args[1]
#if (!require("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")

if(!require(devtools)){
    install.packages("devtools")
    library(devtools)
}


if(!require(flowCore)){
    devtools::install_github("RGLab/flowCore", lib="/homes/lrmeulenkamp/data_process/lib/flowCore/")
    library(flowCore)
}





#log <- file(snake_log, open="wt")
#sink(log)

path <- args[1]
file_list1 <- list.files(path=path)
dataset1 <- data.frame()
for(i in 1:length(file_list1)){
  file_string <- file_list1[i]
  file_string <- paste(path, file_string, sep = "")
  fcs.data <- read.FCS(file_string)
  fcs.data.frame <- as.data.frame(exprs(fcs.data)) 
  dataset1 <- rbind(dataset1, fcs.data.frame)
}

write.csv(dataset1, file = "./CSVdata/dataset1.csv", row.names = FALSE)