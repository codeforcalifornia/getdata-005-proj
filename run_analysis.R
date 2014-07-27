#labels_fn <- "UCI HAR Dataset/activity_labels.txt"
#features_fn <- "UCI HAR Dataset/features.txt"
#features_info_fn <- "UCI HAR Dataset/features_info.txt"

x_test_raw <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test_raw <- read.table("UCI HAR Dataset/test/y_test.txt")
s_test_raw <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train_raw <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train_raw <- read.table("UCI HAR Dataset/train/y_train.txt")
s_train_raw <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Merge activity test and train data sets
y_data <- c(y_train_raw[,1], y_test_raw[,1])
# Merge subject test and train data sets
s_data <- c(s_train_raw[,1], s_test_raw[,1])

# Replace numbers in the activity data set with informative labels
# This will give descriptive activity names to name the activities in the data set.
activity_raw <- read.table("UCI HAR Dataset/activity_labels.txt")
y_data_labeled <- character(nrow(activity_raw))
for (activity in 1:nrow(activity_raw)) {
    y_data_labeled[y_data == activity] <- as.character(activity_raw[activity,2])
}

# Merge X test and train data sets
x_data <- matrix(nrow=(nrow(x_test_raw) + nrow(x_train_raw)), ncol=ncol(x_train_raw))
for (xcol in 1:ncol(x_train_raw)) {
    x_data[,xcol] <- c(x_train_raw[,xcol], x_test_raw[,xcol])
}

# At this point, we have merged the test and train data sets.

# We will now create and populate the tidy data set.
tidy_data <- data.frame(x_data)

# Label the features in the data set with descriptive variable names
features_raw <- read.table("UCI HAR Dataset/features.txt")
features_dat <- features_raw[,2]
for (xcol in seq(1:ncol(x_data))) {
    names(tidy_data)[xcol] <- as.character(features_dat[xcol])
}

# Extract the mean and standard deviation for each measurement
# Instead of using %in%, just hard-code the columns that are known to have
# standard deviation and mean values
ms_cols <- c(1, 2, 3, 41, 42, 43, 81, 82, 83, 121, 122, 123, 161, 162, 163, 201, 214, 227, 240, 253, 266, 267, 268, 345, 346, 347, 424, 425, 426, 503, 516, 529, 542, 4, 5, 6, 44, 45, 46, 84, 85, 86, 124, 125, 126, 164, 165, 166, 202, 215, 228, 241, 254, 269, 270, 271, 348, 349, 350, 427, 428, 429, 504, 517, 530, 543)
tidy_data <- tidy_data[,ms_cols]

# Append activity and subject data to the data set.
tidy_data[,ncol(ms_cols)+1] <- y_data_labeled
tidy_data[,ncol(ms_cols)+2] <- s_data
names(tidy_data)[ncol(ms_cols)+1] <- "activity"
names(tidy_data)[ncol(ms_cols)+2] <- "subject"

# Write out the tidy data set
# Since we will only be submitting the 2nd data set, do not print this one out.
#write.table(tidy_data, file="tidy_data.txt")

subjects <- c(1, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 3, 30, 5, 6, 7, 8)

activities <- c(1, 2, 3, 4, 5, 6)

ds2 <- matrix(nrow=(length(subjects) * length(activities)), ncol=(ncol(x_data) + 2))

# For each subject ...
for (subject_idx in 1:length(subjects)) {
    # For each activity ...
    for (activity in activities) {
        # Determine the subscript where we will store our results
        subscript <- ((subject_idx - 1) * length(activities)) + activity
        x_subset <- x_data[(y_data == activity) & (s_data == subjects[subject_idx]),]
        for (xcol in 1:ncol(x_subset)) {
            ds2[subscript,xcol] <- mean(x_subset[,xcol])
        }
        ds2[subscript,ncol(x_data) + 1] <- activity
        ds2[subscript,ncol(x_data) + 2] <- subjects[subject_idx]
#        print('Incoming data mean')
#        print(ds2[subscript,])
#        print('End data mean')
    }
}

ds2 <- data.frame(ds2)
for (xcol in seq(1:ncol(x_data))) {
    names(ds2)[xcol] <- as.character(features_dat[xcol])
}

for (activity in 1:nrow(activity_raw)) {
    ds2[ds2[,ncol(x_data) + 1] == activity, ncol(x_data) + 1] <- as.character(activity_raw[activity,2])
}

names(ds2)[ncol(x_data) + 1] <- 'activity'
names(ds2)[ncol(x_data) + 2] <- 'subject.id'
write.table(ds2, file="tidy_derived_data.txt")
