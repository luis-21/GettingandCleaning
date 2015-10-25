# Getting and Cleaning Data Project

##Objective of the Project

The repo contains an R script  called run_analysis.R that does the following:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement.
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive activity names.
5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In the repo you will find the data needed to fulfill the above tasks in the folder named UCI HAR Dataset.

##Data Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#run_analysis.R Script 
##Reading data from text files found in the data downloaded from the URL given.
x_test <- read.table('./GettingandCleaning/UCI HAR Dataset/test/X_test.txt')
x_train <- read.table('./GettingandCleaning/UCI HAR Dataset/train/X_train.txt')
y_test <- read.table('./GettingandCleaning/UCI HAR Dataset/test/y_test.txt')
y_train <- read.table('./GettingandCleaning/UCI HAR Dataset/train/y_train.txt')
subj_test <- read.table('./GettingandCleaning/UCI HAR Dataset/test/subject_test.txt')
subj_train <- read.table('./GettingandCleaning/UCI HAR Dataset/train/subject_train.txt')
datafeatures <- read.table('./GettingandCleaning/UCI HAR Dataset/features.txt')
dataactivities <- read.table('./GettingandCleaning/UCI HAR Dataset/activity_labels.txt')

##Merges the data into one data file and extracts the mean and standard deviation for each measurment.
ydata <- rbind(y_train, y_test)
xdata <- rbind(x_train, x_test)
subjdata <- rbind(subj_train, subj_test)
meanStd <- grep("-mean\\(\\)|-std\\(\\)", datafeatures[, 2])
meanStd2 <- xdata[, meanStd]
data <- cbind(subjdata, meanStd2, ydata)


##Writting name of the activities.
names(meanStd2) <- datafeatures[meanStd, 2]
names(meanStd2) <- tolower(names(meanStd2)) 
names(meanStd2) <- gsub("\\(|\\)", "", names(meanStd2))
dataactivities[, 2] <- tolower(as.character(dataactivities[, 2]))
dataactivities[, 2] <- gsub("_", "", dataactivities[, 2])
ydata[, 1] = dataactivities[ydata[, 1], 2]
colnames(ydata) <- 'activity'
colnames(subjdata) <- 'subject'

##Creates a tidy data set with the average of each variable for each activity and each subject.
averagedata <- aggregate(x=data, by=list(Activities=data$activity, Subjects=data$subject), FUN=mean)
averagedata <- averagedata[, !(colnames(averagedata) %in% c("subject", "activity"))]
str(averagedata)
write.table(averagedata, './GettingandCleaning/tidydata.txt', row.names = FALSE)
