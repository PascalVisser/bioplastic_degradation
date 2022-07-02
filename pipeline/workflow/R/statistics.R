args <- commandArgs(trailingOnly=TRUE)

.libPaths("./Rfiles_library/Rlibrary")
library(cluster)

source("workflow/R/Hdbscan.R")

clustering <- function(file_in, NumOfPts = 20){


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

  return(scan)
}
perc_shift <- function(x, y){
  return(((y-x)/x) * 100)
}

perc_clustered <- function(x, y){
  return((y/x) * 100)
}

cluster_vector <- function(x, y){
  vec <- c(x[[1]] - y[[1]], x[[2]] - y[[2]])
  return(sqrt(vec[1]^2 + vec[2]^2))
}

silhouette_scores <- function(data_file){
  sil <- silhouette(data_file[,4], dist(data_file[, c(1:3)]))
  sil <- summary(sil)
  return(sil$clus.avg.widths[[3]])
}

calc_log <- function (file_in){
  # Random samples data if file to big
    if (between(nrow(file_in), 10000, 20000)){
    file_in <- sample_n(file_in, 15000, replace = T)
    memory.limit(size = 16000)
  } else if (nrow(file_in) > 20000){
    file_in <- sample_n(file_in, 28000, replace = T)
    memory.limit(size = 16000)
  }

  # strip all columns except fsc ,ssc and width
  modified <- file_in[,c(1,2,13)]

  # if there are NA's, replaces them with the mean
  modified[modified == 0] <- NA

  for(i in 1:ncol(modified)){
    modified[is.na(modified[,i]), i] <- mean(modified[,i], na.rm = TRUE)
  }

  # log transform file
  return(log2(modified))
}

calc_coords <- function(log_file, DBscan){

   cluster <- 2


  log_file["cluster"] <- DBscan$cluster

  log_frame <- log_file[log_file$cluster != 0, c(1:4)]


  sum_cluster_1_FSC <- sum(log_frame[log_frame$cluster == cluster, c(1)])
  sum_cluster_1_SSC <- sum(log_frame[log_frame$cluster == cluster, c(2)])

  total_cluster1_FSC <- length(log_frame[log_frame$cluster == cluster, c(1)])
  total_cluster1_SSC <- length(log_frame[log_frame$cluster == cluster, c(2)])

  center_1 <- data.frame(FSC = sum_cluster_1_FSC / total_cluster1_FSC,
                       SSC = sum_cluster_1_SSC / total_cluster1_SSC)
  return(center_1)
}


# user gives two directories
first_file <- gsub("\\[|,|\\]", "" ,args[1])

second_file <- gsub("\\[|,|\\]", "" ,args[2])

full_path1 <- list.files(path = paste0(first_file,"/csv"), pattern = "map[0-9]+.csv", full.names = TRUE)
full_path2 <- list.files(path = paste0(second_file,"/csv"), pattern = "map[0-9]+.csv", full.names = TRUE)

csv_name1 <- basename(full_path1)
file_name1 <- tools::file_path_sans_ext(csv_name1)
csv_name2 <- basename(full_path2)
file_name2 <- tools::file_path_sans_ext(csv_name2)

dataset1 <- read.csv(full_path1)
dataset2 <- read.csv(full_path2)

DBscan1 <- clustering(dataset1, points_calc(dataset1))
DBscan2 <- clustering(dataset2, points_calc(dataset2))

map1_log <- calc_log(dataset1)
map2_log <- calc_log(dataset2)


map1_cluster <- cbind(map1_log, DBscan1$cluster)
map2_cluster <- cbind(map2_log, DBscan2$cluster)


map2_FSC_shift <- map2_cluster[map2_cluster$`DBscan2$cluster` == 2,1]
map1_FSC_shift <- map1_cluster[map1_cluster$`DBscan1$cluster` == 2,1]

map2_SSC_shift <- map2_cluster[map2_cluster$`DBscan2$cluster` == 2,2]
map1_SSC_shift <- map1_cluster[map1_cluster$`DBscan1$cluster` == 2,2]

map2_width_shift <- map2_cluster[map2_cluster$`DBscan2$cluster` == 2,3]
map1_width_shift <- map1_cluster[map1_cluster$`DBscan1$cluster` == 2,3]


#All variables are written into csv file
FSC.change <- perc_shift(mean(map2_FSC_shift), mean(map1_FSC_shift))
SSC.change <- perc_shift(mean(map2_SSC_shift), mean(map1_SSC_shift))
Width.change <- perc_shift(mean(map2_width_shift), mean(map1_width_shift))

coords_dataset2 <- calc_coords(map2_log, DBscan2)
coords_dataset1 <- calc_coords(map1_log, DBscan1)

clust_vec <- cluster_vector(coords_dataset2, coords_dataset1)

total_points2 <- dim(dataset2)[1]
points_clustered2 <- dim(map2_cluster[map2_cluster$`DBscan2$cluster` == c(1, 2),])[1]
perc_clustered2 <- perc_clustered(total_points2, points_clustered2)

silhouette_score2 <- silhouette_scores(map2_cluster)

map2_result <- data.frame("coords" = coords_dataset2,
                          "total_points" = total_points2,
                          "points_clustered" = points_clustered2,
                          "perc_clustered" = perc_clustered2,
                          "silhouette_score" = silhouette_score2)
row.names(map2_result) <- c(file_name2)


total_points1 <- dim(dataset1)[1]
points_clustered1 <- dim(map1_cluster[map1_cluster$`DBscan1$cluster` == c(1, 2),])[1]
perc_clustered1 <- perc_clustered(total_points1, points_clustered1)

silhouette_score1 <- silhouette_scores(map1_cluster)

map1_result <- data.frame("coords" = coords_dataset1,
                          "total_points" = total_points1,
                          "points_clustered" = points_clustered1,
                          "perc_clustered" = perc_clustered1,
                          "silhouette_score" = silhouette_score1)

row.names(map1_result) <- c(file_name1)


both_result <- data.frame("FSC.change" = FSC.change,
                     "SSC.change" = SSC.change,
                     "Width.change" = Width.change,
                     "cluster_vector" = clust_vec)

maps_result <- rbind(map1_result, map2_result)

compare_path <- sprintf("results/%svs%s/", file_name1, file_name2)
both_name <- sprintf("changes_%s-%s.csv", file_name1, file_name2)
compare_name <- sprintf("scores_%s-%s.csv", file_name1, file_name2)

dir.create(compare_path, showWarnings = FALSE)
write.csv(both_result, paste0(compare_path,both_name), row.names=FALSE)
write.csv(maps_result, paste0(compare_path,compare_name))

