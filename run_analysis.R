
#Reading data
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
subj_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subj_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')

#Merging
ydata <- rbind(y_train, y_test)
xdata <- rbind(x_train, x_test)
subjdata <- rbind(subj_train, subj_test)


 #Mean and Std
datafeatures <- read.table('./UCI HAR Dataset/features.txt')
meanStd <- grep("-mean\\(\\)|-std\\(\\)", datafeatures[, 2])
meanStd2 <- xdata[, meanStd]

#Name of the activities
names(meanStd2) <- datafeatures[meanStd, 2]
names(meanStd2) <- tolower(names(meanStd2)) 
names(meanStd2) <- gsub("\\(|\\)", "", names(meanStd2))
dataactivities <- read.table('./UCI HAR Dataset/activity_labels.txt')
dataactivities[, 2] <- tolower(as.character(dataactivities[, 2]))
dataactivities[, 2] <- gsub("_", "", dataactivities[, 2])
ydata[, 1] = dataactivities[ydata[, 1], 2]
colnames(ydata) <- 'activity'
colnames(subjdata) <- 'subject'

#Data labeling
data <- cbind(subjdata, meanStd2, ydata)

#tidy data
averagedata <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
averagedata <- averagedata[, !(colnames(averagedata) %in% c("subj", "activity"))]
str(averagedata)
write.table(averagedata, './tidy/average.txt', row.names = FALSE)