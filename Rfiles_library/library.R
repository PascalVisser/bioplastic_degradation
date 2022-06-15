# Package installation

## Requirements 
# - change lib = '' to desired installation directory
# - cytolib directory MUST be in same installation directory 
# - .libPaths() must be also the same library directory


# set library path to right directory
.libPaths("Rlibrary")

start_time <- Sys.time()

# check if devtool package exist, otherwise install it
is_devtools_installed <- require("devtools")
if (is_devtools_installed == FALSE){
  install.packages("devtools", lib = "Rlibrary")
} else {
}


# check if BiocManager package exist, otherwise install it
is_BiocManager_installed <- require("BiocManager")
if (is_BiocManager_installed == FALSE) {
  if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", lib = "Rlibrary")
} else {
}


# check if flowCore package exist, otherwise install it
is_flowCore_installed <- require("flowCore")
if (is_flowCore_installed == FALSE) {
  BiocManager::install("flowCore", lib = "Rlibrary")
} else {
}


# check if dbscan package exist, otherwise install it
is_dbscan_installed <- require("dbscan")
if (is_dbscan_installed == FALSE) {
  install.packages("dbscan", lib = "Rlibrary")
} else {
}


# check if dplyr package exist, otherwise install it
is_dplyr_installed <- require("dplyr")
if (is_dplyr_installed == FALSE) {
  install.packages("dplyr", lib = "Rlibrary")
} else {
} 


end_time <- Sys.time()

cat("\nCompleted in", round(end_time - start_time, 2) , "seconds","\n")    




