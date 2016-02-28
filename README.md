The GitHub for my “Getting and Cleaning Data Course Project” contains the following files:

# Summary

* A tidy data set named “averages.csv” with the average of each variable for each activity and each subject. This data is tidy because each variable is in one column (“subject”, activity “label”, “measurement”, and “mean(value)”), I did not manipulate any of the numbers in the data, I did not remove any data from the data set, and I did not summarize the data in any way. For the latter two, I did not remove any or summarize the data beyond what is called for in the assignment. Additionally, I included a row at the top of each file with human readable variable names.
* The required “run_analysis.R” script. A summary of this script can be found below.
* A code book indicating all the variables and summaries calculated, along with units
* “README.md”, which you are currently reading

# run_analysis.R

* This function has no arguments and begins by downloading the data for the project, unzipping it, and entering the “UCI HAR Dataset” directory. All you need to do is download, source, and run the script. The data will download and tidy data set “averages.csv” will write to the present working directory.
* Then it reads the training and test sets to separate data tables for the subject, measurements, and activity labels.
* Next, it reads the list of all features, keeping only the second column, which contains the names of measurements.
* From this file, it then extracts only the measurements on the mean and standard deviation for each measurement and finds the column numbers for means and standard deviations.
* Then it subsets the list of all features, training, and test measurements to include only means and standard deviations.
* Afterwards, it labels the latter two data sets with descriptive variable names using the subsetted list of all features as headers for the subsetted training and test measurements.
* Next, it builds a data table for the training and test sets containing variables for the set (i.e. training or test), subject (1-30), activity label (1-6), and measurements.
* Then I merge the training and test sets to create one data set and use descriptive activity names to name the activities in the data set.
* Finally, I gather the measurements and their values into two columns, group the data table by subject, activity, and variable, and calculate the average of each variable for each activity and each subject.
* Write the resulting data table to a file named “averages.csv”, which can be read using the read.csv() command.