args <- commandArgs(trailingOnly=TRUE)

path_files <- args[1]
source("Hdbscan.R")


perc_shift <- function(x, y){
  return(((y-x)/x) * 100)
}
perc_clustered <- function(x, y){
  return((y/x) * 100)
}
cluster_vector <- function(x, y){
  vec <- c(x[1] - y[1], x[2] - y[2])
  return(sqrt(vec[1]^2 + vec[2]^2))
}
silhouette_scores <- function(data_file){
  sil <- silhouette(data_file[,15], dist(data_file[, c(1:14)]))
  return(summary(sil))
}
calc_coords <- function(in_file, cluster=1){
  log_file <- calc_log(in_file)

  DBscan <- db_clustering(in_file, points_calc(in_file))

  log_file["cluster"] <- DBscan$cluster

  log_frame <- log_file[log_file$cluster != 0, c(1:3)]


  sum_cluster_1_FSC <- sum(log_frame[log_frame$cluster == cluster, c(1)])
  sum_cluster_1_SSC <- sum(log_frame[log_frame$cluster == cluster, c(2)])

  total_cluster1_FSC <- length(log_frame[log_frame$cluster == cluster, c(1)])
  total_cluster1_SSC <- length(log_frame[log_frame$cluster == cluster, c(2)])

  center_1 <- data.frame(x = sum_cluster_1_FSC / total_cluster1_FSC,
                       y = sum_cluster_1_SSC / total_cluster1_SSC)
  return(center_1)
}

file_list <- list.files(path=path_files, full.names = TRUE, pattern=".csv")
in_file <- read.csv(file_list)

coords <- calc_coords(in_file)
trans_
FSC.change <- perc_shift(mean("Dataset2$FSC.A voor cluster"), mean("Dataset1$FSC.A voor cluster"))
SSC.change <- perc_shift(mean("Dataset2$SSC.A voor cluster"), mean("Dataset1$SSC.A voor cluster"))
Width.chane <- perc_shift(mean("Dataset2$Width voor cluster"), mean("Dataset1$Width voor cluster"))
cluster_vector("Center cluster 2", "Center cluster 1")
total_points <- dim("dataset")[1]
points_clustered <- dim("alle geclusterde punten in dataset")[1]
total_clustered <- perc_clustered(total_points, points_clustered)
silhouette_score <- silhouette_scores("dataset")





