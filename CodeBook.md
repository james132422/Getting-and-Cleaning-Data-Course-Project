# Description for the data set, the variables and the transformation code

## Data
After running the ***"run_analysis.R"*** script, the combined data frame (from train and test) with extracted sensor variables, subject IDs, and activity are stored in the object "DF". The tidied data frame with the average of each variable for each activity and each subject is stored in the object "tidyDF" and output to the text file *"tidyDF.txt"*.

## Variables
The variables are extracted as required by the assignment containing only the measurements on the mean and standard deviation for each measurement. The indices of the required variables and their corresponding names are obtained by the following three lines of code:
```
features <- read.delim("./UCI HAR Dataset/features.txt", header=FALSE)   
extract_index <- grepl("(mean|std)\\(", features$V1)  
feature_names <- features$V1[extract_index]
```  
The code further processes the object "feature_names" to remove the number part and leave only the descriptive string:
```
secondElement <- function(x){x[2]}
feature_names <- sapply(strsplit(feature_names, " "), secondElement)
```
The descriptive activity label names are read from the *"activity_labels.txt"* file:
```
activity_labels <- readLines("./UCI HAR Dataset/activity_labels.txt")
```

## Transformation
The code first read and merge the train and test data sets with extracted variables:
```
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[, extract_index]
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[, extract_index]
X_total <- rbind(X_train, X_test)
```
and the corresponding subject IDs and activities for each entry:
```
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_total <- rbind(y_train, y_test)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_total <- rbind(subject_train, subject_test)
```
Assign the extracted descriptive variable names to the column names of the "X_total" object:
```
names(X_total) <- feature_names
```
We use the pipeline operator to chain the operations of adding the activity and subject ID column, renaming the activity to give descriptive column name, and removing the number part in the activity data.
```
DF <- mutate(X_total, activity=y_total[,1], SubjectId=subject_total[,1]) %>% 
    mutate(activity=activity_labels[activity]) %>% 
    mutate(activity=sapply(strsplit(activity, " "), secondElement))
```
The "DF" object corresponds to the result required by the (end of) step 4 of the assignment instruction.\
\
A tidy data frame/set is created by melting the re-casting the "DF" object so that the average of the (extracted) variables for each activity and each subject is listed:
```
DFmelt <- melt(DF, id.vars=c("SubjectId", "activity"))
tidyDF <- dcast(DFmelt, SubjectId+activity~variable, mean)
write.table(tidyDF, "tidyDF.txt", row.names = FALSE)
```
The object "tidyDF" corresponds to the tidy data set required by the step 5 of the assignment instruction and is output to a text file called *"tidyDF.txt"*.
