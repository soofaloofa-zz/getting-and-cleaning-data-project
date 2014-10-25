# This script reads the activity data from the UCI HAR Dataset and, for
# each test subject and activity, outputs the mean of the measurements made.

library(dplyr)

# 1. Merge the training and the test sets to create one data set.
# 4. Appropriately label the data set with descriptive variable names.

# Extract the feature names
featureNames <- read.table('./UCI HAR Dataset/features.txt')[,2]

# Load and merge the training and test features
featureNames <- read.table('./UCI HAR Dataset/features.txt')[,2]
trainFeatures <- read.table('./UCI HAR Dataset/train/X_train.txt', col.names=featureNames)
testFeatures <- read.table('./UCI HAR Dataset/test/X_test.txt', col.names=featureNames)
features <- rbind(trainFeatures, testFeatures)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.

# Use grep to extract only the mean and standard deviation columns from the feature names.
usedFeatures <- grep('mean|std', featureNames, ignore.case=TRUE)
features <- features[,usedFeatures]

# 3. Use descriptive activity names to name the activities in the data set.

# Add the training and test subjects to the data set
trainSubjectIndex <- read.table('./UCI HAR Dataset/train/subject_train.txt', col.names='Subject.Index')
testSubjectIndex <- read.table('./UCI HAR Dataset/test/subject_test.txt', col.names='Subject.Index')
subjects <- rbind(trainSubjectIndex, testSubjectIndex)
features <- cbind(subjects, features)

# Read the activity indices for the training and test data
trainActivityIndex <- read.table('./UCI HAR Dataset/train/y_train.txt', col.names='Activity.Index')
testActivityIndex <- read.table('./UCI HAR Dataset/test/y_test.txt', col.names='Activity.Index')
activities <- rbind(trainActivityIndex, testActivityIndex)

# Merge the labels with the indices, applying an index to the data to maintain
# the correct sort order after merging
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt', col.names=c('Activity.Index', 'Activity.Label'))
activities$id <- 1:nrow(activities)  # Apply an index to the data
activities <- merge(activityLabels, activities)
activities <- activities[order(activities$id), ]

# Add the activity labels to the data set
features <- cbind(activities$Activity.Label, features)
colnames(features)[1] <- "Activity.Label" 

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
grouped <- group_by(features, Activity.Label, Subject.Index)
summarized <- summarise_each(grouped, funs(mean))

# Write the output to a file
write.table(summarized, row.name=F, file='./output.txt')
