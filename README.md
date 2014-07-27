getdata-004-proj
================

This is the code to produce the rproj004 project solution.  It performs the
following:

It merges the training and test sets to create one data set.
Extracts only the measurements on the mean and standard deviation.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive variable names.
Outputs this data set.
Creates a second, independent tidy data set with the average of each variable
for each activity and each subject.
Outputs this 2nd data set.

Had I the time, I would have preferred to programmatically obtain the position
of columns using string pattern matching, added the subject and activity
columns without hard-coding the column number, and done a lot of cleanup.  But,
due to time pressures, this is what I have instead.
