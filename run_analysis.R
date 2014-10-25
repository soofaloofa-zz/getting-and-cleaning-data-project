library(dplyr)

# 1. Merge the training and the test sets to create one data set.
# 4. Appropriately label the data set with descriptive variable names.
featureNames <- read.table('./UCI HAR Dataset/features.txt')[,2]

trainFeatures <- read.table('./UCI HAR Dataset/train/X_train.txt', col.names=featureNames)
testFeatures <- read.table('./UCI HAR Dataset/test/X_test.txt', col.names=featureNames)
features <- rbind(trainFeatures, testFeatures)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
featureNames <- read.table('./UCI HAR Dataset/features.txt')[,2]
usedFeatures <- grep('mean|std', featureNames, ignore.case=TRUE)
features <- features[,usedFeatures]


# Add the subject index to the dataset
trainSubjectIndex <- read.table('./UCI HAR Dataset/train/subject_train.txt', col.names='Subject.Index')
testSubjectIndex <- read.table('./UCI HAR Dataset/test/subject_test.txt', col.names='Subject.Index')
subjects <- rbind(trainSubjectIndex, testSubjectIndex)
features <- cbind(subjects, features)

# 3. Use descriptive activity names to name the activities in the data set.
trainActivityIndex <- read.table('./UCI HAR Dataset/train/y_train.txt', col.names='Activity.Index')
testActivityIndex <- read.table('./UCI HAR Dataset/test/y_test.txt', col.names='Activity.Index')
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt', col.names=c('Activity.Index', 'Activity.Label'))
activities <- rbind(trainActivityIndex, testActivityIndex)
activities$id <- 1:nrow(activities)  # Apply an index to the data
activities <- merge(activityLabels, activities)
activities <- activities[order(activities$id), ]
features <- cbind(activities$Activity.Label, features)
colnames(features)[1] <- "Activity.Label" 

# 5.  then you are taking the mean for each grouping Subject+Activity.
grouped <- group_by(features, Activity.Label, Subject.Index)
summarized <- summarise_each(grouped, funs(mean))