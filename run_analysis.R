library(data.table)
library(stringr)
library(dplyr)

# Extract the required variables' indices and their descriptive names
features <- read.delim("./UCI HAR Dataset/features.txt", header=FALSE)
extract_index <- grepl("(mean|std)\\(", features$V1)
feature_names <- features$V1[extract_index]
secondElement <- function(x){x[2]}
feature_names <- sapply(strsplit(feature_names, " "), secondElement)
activity_labels <- readLines("./UCI HAR Dataset/activity_labels.txt")

# Read, combine data sets and rename variables
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[, extract_index]
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[, extract_index]
X_total <- rbind(X_train, X_test)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_total <- rbind(y_train, y_test)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_total <- rbind(subject_train, subject_test)
names(X_total) <- feature_names
DF <- mutate(X_total, activity=y_total[,1], SubjectId=subject_total[,1]) %>% 
    mutate(activity=activity_labels[activity]) %>% 
    mutate(activity=sapply(strsplit(activity, " "), secondElement))

# Reshape the data set to produce tidy data set by melt() and dcast() functions
DFmelt <- melt(DF, id.vars=c("SubjectId", "activity"))
tidyDF <- dcast(DFmelt, SubjectId+activity~variable, mean)
write.table(tidyDF, "tidyDF.txt", row.names = FALSE)