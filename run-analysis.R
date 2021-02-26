library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels + features
activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_Labels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
wanted_features <- grep(".*mean.*|.*std.*", features[,2])
wanted_features.names <- features[wanted_features,2]
wanted_features.names = gsub('-mean', 'Mean', wanted_features.names)
wanted_features.names = gsub('-std', 'Std', wanted_features.names)
wanted_features.names <- gsub('[-()]', '', wanted_features.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[wanted_features]
train_Activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_Subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_Subjects, train_Activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[wanted_features]
test_Activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_Subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_Subjects, test_Activities, test)

# merge datasets and add labels
all_Data <- rbind(train, test)
colnames(allData) <- c("subject", "activity", wanted_features.names)

# turn activities & subjects into factors
all_Data$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
all_Data$subject <- as.factor(allData$subject)

all_Data.melted <- melt(all_Data, id = c("subject", "activity"))
all_Data.mean <- dcast(all_Data.melted, subject + activity ~ variable, mean)

write.table(all_Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)