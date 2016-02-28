run_analysis <- function() {
  
  library(data.table)
  library(dplyr)
  library(tidyr)
  
  #Download data for the project
  download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                destfile = "data.zip", method = "curl")
  unzip(zipfile = "data.zip")
  setwd("UCI HAR Dataset/")
  
  #Read the training set to data tables
  setwd("train/")
  train_subject <- fread(input = "subject_train.txt")
  train_measurements <- fread(input = "X_train.txt")
  train_labels <- fread(input = "y_train.txt")
  setwd("../")
  
  #Read the test set to a data table
  setwd("test/")
  test_subject <- fread(input = "subject_test.txt")
  test_measurements <- fread(input = "X_test.txt")
  test_labels <- fread(input = "y_test.txt")
  setwd("../")
  
  #Read list of all features
  features <- fread("features.txt", select = c(2))
  
  #Extracts only the measurements on the mean and standard deviation for 
  #each measurement.
  #Find column numbers for means and standard deviations
  mean_columns <- grep(pattern = "mean", x = features$V2)
  std_columns <- grep(pattern = "std", x = features$V2)
  keep_columns <- sort(x = as.vector(x = c(mean_columns, 
                                           std_columns)))
  
  #Subset list of all features
  features_mean_std <- features[keep_columns]
  
  #Subset training and test measurements to include only means
  #and standard deviations
  train_mean_std <- train_measurements[, keep_columns, 
                                       with = FALSE]
  test_mean_std <- test_measurements[, keep_columns,
                                     with = FALSE]
  
  #Label the data set with descriptive variable names
  #Use the subsetted list of all features as headers for the 
  #subsetted training and test measurements
  for (i in 1:ncol(x = train_mean_std)) {
    name <- as.character(x = features_mean_std[i])
    names(x = train_mean_std)[i] <- name
    names(x = test_mean_std)[i] <- name
  }
  
  #Build data table for training set
  training_set <- data.table(set = rep(x = "train",
                                       times = nrow(x = train_mean_std)), 
                             subject = train_subject$V1, 
                             label = train_labels$V1)
  training_set <- cbind(training_set, train_mean_std)
  
  #Build data table for test set
  test_set <- data.table(set = rep(x = "test", 
                                   times = nrow(x = test_mean_std)), 
                         subject = test_subject$V1, 
                         label = test_labels$V1)
  test_set <- cbind(test_set, test_mean_std)
  
  #Merge the training and the test sets to create one data set]
  setkey(x = training_set)
  setkey(x = test_set)
  merged <- merge(x = training_set, y = test_set, all = TRUE)
  
  #Uses descriptive activity names to name the activities in the data set
  merged$label[merged$label == 1] <- "WALKING"
  merged$label[merged$label == 2] <- "WALKING_UPSTAIRS"
  merged$label[merged$label == 3] <- "WALKING_DOWNSTAIRS"
  merged$label[merged$label == 4] <- "SITTING"
  merged$label[merged$label == 5] <- "STANDING"
  merged$label[merged$label == 6] <- "LAYING"
  
  #Gather measurements and their values into two columns
  gathered <- gather(data = merged, key = measurement, value = value, c(4:ncol(merged)))
  
  #Group data table by subject, activity, and variable
  grouped <- group_by(.data = gathered, subject, label, measurement)
  
  #Calculate average of each variable for each activity and each subject
  averages <- summarise(.data = grouped, mean(value))
  
  #Write averages to a .csv file
  setwd("../")
  averages_df <- as.data.frame(averages)
  write.csv(x = averages_df, file = "averages.csv")
  
}