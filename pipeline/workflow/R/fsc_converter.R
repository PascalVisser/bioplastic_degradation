args <- commandArgs(trailingOnly=TRUE)
.libPaths("./Rfiles_library/Rlibrary")
library(flowCore)
suppressPackageStartupMessages({library(plyr)})
suppressPackageStartupMessages({library(dplyr)})
suppressPackageStartupMessages({library(readr)})
suppressPackageStartupMessages({library(purrr)})



options(readr.show_col_types = FALSE)
for (path in args){
   full_path <- list.files(path = path, pattern = "*.fcs", full.names = TRUE)

  for(file in full_path){
      dataset <- data.frame()
      file_name <- basename(file)
      dir_name <- dirname(file)
      fcs.data <- read.FCS(file)
      fcs.data.frame <- as.data.frame(exprs(fcs.data))
      dataset <- rbind(dataset, fcs.data.frame)
      write.csv(dataset, file = paste0(dir_name,"/csv/",file_name,".csv"), row.names = FALSE)

  }
  all_csv <- list.files(path = paste0(path,"/csv"), pattern = "*.csv", full.names = TRUE)
  data <- all_csv %>%
      map(read_csv) %>%
      reduce(rbind)
  direct_name <- dirname(all_csv)
  mapNum <- basename(path)
  write.csv(data, file = paste0(direct_name[1],"/",mapNum,".csv"), row.names = FALSE)
}


