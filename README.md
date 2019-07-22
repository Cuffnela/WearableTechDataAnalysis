# Getting and Cleaning Data Course Project

This is the final course project for the Getting and Cleaning Data course by Johns Hopkins University on Coursera. The program run_analysis.R creates a tidy data set with the average of each variable for each activity and each subject from the UCI HAR Dataset. The R script, run_analysis.R, does the following:

1. Loads the test data and features file (contains variable names)
2. Creates readable headers for loaded test data
3. Reduces test data to only column variables that contain mean or standard deviation values. 
4. Creates a dataframe of the cleaned and reduced test data. 
5. Repeats steps 1 - 4 for the training data. 
6. Merges the two datasets (test and train)
7. Melts data into skinny data set
8. Uses dcast to find the average of the 66 mean/std variables.
9. Creates a tidy data set arranged by activity and subject ID and write to a text file. 

The end result is shown in the tidydata.txt file. To recreate this process download the UCI HAR Dataset provided in this repository.
