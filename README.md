The script ***"run_analysis.R"*** requires the following R packages: **data.table**, **stringr**, **dplyr**. And can be run as long as the data folder "UCI HAR Dataset" exists in the working directory. The script reads and processes the original data sets and outputs a tidied table/data frame to the file *"tidyDF.txt"*. Detailed descriptions of the data, the variables and the transformation code performed are included in the *"CodeBook.md"* markdown file.
\
\
Overview of the analysis performed by ***"run_analysis.R"***:
\
\
1. Merges the training and the test sets to create one data set.\
2. Extracts only the measurements on the mean and standard deviation for each measurement.\
3. Uses descriptive activity names to name the activities in the data set.\
4. Appropriately labels the data set with descriptive variable names.\
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.