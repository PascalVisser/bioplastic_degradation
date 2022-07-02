# Package installation

## Requirements 
# - change lib = '' to desired installation directory
# - cytolib directory MUST be in same installation directory 
# - .libPaths() must be also the same library directory


# set library path to right directory
path <- "Rfiles_library/Rlibrary/"
.libPaths(path)

start_time <- Sys.time()

# check if devtool package exist, otherwise install it
is_devtools_installed <- require("devtools")
if (is_devtools_installed == FALSE){
  install.packages("devtools", lib = path)
} else {
}


# check if BiocManager package exist, otherwise install it
is_BiocManager_installed <- require("BiocManager")
if (is_BiocManager_installed == FALSE) {
  if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", lib = path)
} else {
}


# check if flowCore package exist, otherwise install it
is_flowCore_installed <- require("flowCore")
if (is_flowCore_installed == FALSE) {
  BiocManager::install("flowCore", lib = path)
} else {
}


# check if dbscan package exist, otherwise install it
is_dbscan_installed <- require("dbscan")
if (is_dbscan_installed == FALSE) {
  install.packages("dbscan", lib = path)
} else {
}



# check if plyr package exist, otherwise install it
is_plyr_installed <- require("plyr")
if (is_plyr_installed == FALSE) {
  install.packages("plyr", lib = path)
} else {
}



# check if dplyr package exist, otherwise install it
is_dplyr_installed <- require("dplyr")
if (is_dplyr_installed == FALSE) {
  install.packages("dplyr", lib = path)
} else {
}

# check if readr package exist, otherwise install it
is_readr_installed <- require("readr")
if (is_readr_installed == FALSE) {
  install.packages("readr", lib = path)
} else {
}

# check if purrr package exist, otherwise install it
is_purrr_installed <- require("purrr")
if (is_purrr_installed == FALSE) {
  install.packages("purrr", lib = path)
} else {
}

end_time <- Sys.time()

cat("\nCompleted in", round(end_time - start_time, 2) , "seconds","\n")




