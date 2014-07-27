getdata-005-proj
================

This is thr code to produce the project solution for Getting and Cleaning
Data.  It performs the following:

It merges the training and test sets to create one data set.
Extracts only the measurements on the mean and standard deviation.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive variable names.
Due to ambiguity in the project instructions, this data set is not output.

Creates a second, independent tidy data set with the average of each variable
for each activity and each subject.  For this data set, every line corresponds
to a unique subject/activity pair, and each column refers to a data point.
Outputs this data set.

Had I the time, I would have preferred to programmatically obtain the position
of columns using string pattern matching, added the subject and activity
columns without hard-coding the column number, and done a lot of cleanup.  But,
due to time pressures, this is what I have instead.

Heavy use of the dataset from the following publication is used in this assignment:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

