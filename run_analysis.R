#labels_fn <- "UCI HAR Dataset/activity_labels.txt"
#features_fn <- "UCI HAR Dataset/features.txt"
#features_info_fn <- "UCI HAR Dataset/features_info.txt"

x_test_raw <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test_raw <- read.table("UCI HAR Dataset/test/y_test.txt")
s_test_raw <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train_raw <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train_raw <- read.table("UCI HAR Dataset/train/y_train.txt")
s_train_raw <- read.table("UCI HAR Dataset/train/subject_train.txt")

y_data <- c(y_train_raw[,1], y_test_raw[,1])
s_data <- c(s_train_raw[,1], s_test_raw[,1])

activity_raw <- read.table("UCI HAR Dataset/activity_labels.txt")

for (activity in 1:nrow(activity_raw)) {
    y_data[y_data == activity] <- as.character(activity_raw[activity,2])
}

x_data <- matrix(nrow=(nrow(x_test_raw) + nrow(x_train_raw)), ncol=ncol(x_train_raw))

for (xcol in 1:ncol(x_train_raw)) {
    x_data[,xcol] <- c(x_train_raw[,xcol], x_test_raw[,xcol])
}

# Instead of using %in%, just hard-code the columns that are known to have std
# and mean values
ms_cols <- c(1, 2, 3, 41, 42, 43, 81, 82, 83, 121, 122, 123, 161, 162, 163, 201, 214, 227, 240, 253, 266, 267, 268, 345, 346, 347, 424, 425, 426, 503, 516, 529, 542, 4, 5, 6, 44, 45, 46, 84, 85, 86, 124, 125, 126, 164, 165, 166, 202, 215, 228, 241, 254, 269, 270, 271, 348, 349, 350, 427, 428, 429, 504, 517, 530, 543)

tidy_data <- data.frame(x_data)
tidy_data <- tidy_data[,ms_cols]

features_raw <- read.table("UCI HAR Dataset/features.txt")
features_dat <- features_raw[,2]

for (xcol in seq(1:length(ms_cols))) {
    names(tidy_data)[xcol] <- as.character(features_dat[ms_cols[xcol]])
}

tidy_data[,67] <- y_data
tidy_data[,68] <- s_data
names(tidy_data)[67] <- "activity"
names(tidy_data)[68] <- "subject"

write.table(tidy_data, file="tidy_data.txt")

subjects <- c(1, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 3, 30, 5, 6, 7, 8)

activities <- c(1, 2, 3, 4, 5, 6)

ds2 <- matrix(nrow=(length(subjects) * length(activities)), ncol=(length(ms_cols) + 2))

for (subject_idx in 1:length(subjects)) {
    for (activity in activities) {
        for (variable in 1:length(ms_cols)) {
            subscript <- ((subject_idx - 1) * length(activities)) + activity
            data_mean <- mean(tidy_data[(tidy_data[,67] == activity) & (tidy_data[,68] == subjects[subject_idx]),])
            #message(paste(c(subscript, ' ', subject_idx, ' ', activity, ' ', variable)))
            ds2[subscript, variable] <- data_mean
            ds2[subscript,67] <- activity
            ds2[subscript,68] <- subjects[subject_idx]
        }
    }
}

ds2 <- data.frame(ds2)
names(ds2) <- names(tidy_data)
write.table(ds2, file="tidy_derived_data.txt")
