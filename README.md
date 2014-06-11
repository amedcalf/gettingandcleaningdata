#Readme for Coursera assignment on "Getting and Cleaning Data"

The purpose of the accompanying script is to take a dataset consisting of several files collected from the accelerometers from the Samsung Galaxy S smartphone which is available from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and combine/transform/reshape it so that its output:

*Merges the training and the test sets to create one data set.
*Extracts only the measurements on the mean and standard deviation for each measurement. 
*Uses descriptive activity names to name the activities in the data set
*Appropriately labels the data set with descriptive variable names. 
*Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

By tidy, it means the dataset should:
* have each variable in 1 column
* each observeration in a different row
* any special or unusual characters removed from the column names, and the resulting names made lower case for consistency.

##Output

The variable names in the tidy dataset are explain in the codebook accompanying this called "codebook.txt".

The R script that carries out the transformations needed is called run_analysis.R and accompanies this file in the github repository.

The tidy data set will be written out to a comma seperated text file called "tidyfile.txt" also in the working directory.

##Requirements

It requires:
- all the input data files to be placed in the same working directory as the script is in, no subfolders. These are the files X_test.txt X_train.txt features.txt activity_labels.txt, y_train.txt, y_test.txt, subejct_train.txt, subject_test.txt.
- the above folder to be your current working directory in R.
- access to the R libraries "reshape2" and "plyr"

##Approach

The approach is:

- read in all data files
- union the test and training data into 1 table, likewise theh subject and activities table, preserving the order of the records.
- read in the names from the features description file, clean them up by removing special characters and insisting on lower case, and then use them as names for the main test and training data consolidation.
- next combine the data, subject and activities files together to ensure each data item can be linked to a subject and an activity.
- melt & aggregate the table based on the variable, activity name, activity code and subject to calculate the mean for each combination of subject, activity ID/name and variable measured
- write out this result to "tidyfile.csv".