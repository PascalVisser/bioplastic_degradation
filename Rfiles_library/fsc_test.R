.libPaths("/homes/pvisser/Rfiles_library/Rlibrary")
library(flowCore)

file_list1 <- list.files(path="PHBV_Micha1/")
dataset1 <- data.frame()
for(i in 1:length(file_list1)){
  file_string <- file_list1[i]
  file_string <- paste("PHBV_Micha1/", file_string, sep = "")
  fcs.data <- read.FCS(file_string)
  fcs.data.frame <- as.data.frame(exprs(fcs.data)) 
  dataset1 <- rbind(dataset1, fcs.data.frame)
}

write.csv(dataset1, file = "dataset1.csv", row.names = FALSE)