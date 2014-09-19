# Getting and Cleaning Data - Course Project

## LIBRARIES ##

#library(data.table)
library(tidyr)
library(dplyr)


## FUNCTIONS ##

getDataset <- function(data_dir, folder, feature_labels){

    # Load the bulk of the data set
    #   file: X_<folder>.txt = data set
    data_file <- paste(data_dir, "/", folder, "/", "X_", folder, ".txt", sep="")
    #data <- read.fwf(data_file,
    #                 widths=c(-1, rep(16, times=length(feature_labels))),
    #                 col.names=feature_labels,
    #                 stringsAsFactors=FALSE)
    data <- read.table(data_file, col.names=feature_labels, stringsAsFactors=FALSE)

    # Load the subject_id column
    #   file: subject_<folder>.txt = 1 column: subject_id
    subject_file <- paste(data_dir, "/", folder, "/", "subject_", folder, ".txt", sep="")
    subject_ids <- read.table(subject_file)[[1]] #return just a vector

    # Load the activity_id column
    #   file: y_<folder>.txt = 1 column: activity (factors)
    activity_file <- paste(data_dir, "/", folder, "/", "y_", folder, ".txt", sep="")
    activity_ids <- read.table(activity_file)[[1]] #return just a vector

    # Check number of rows match for all 3 input files
    if (nrow(data) != length(subject_ids)) stop("input files row counts are not equal")
    if (length(subject_ids) != length(activity_ids)) stop("input files row counts are not equal")

    # Glue together the columns and return the data
    cbind(data, subject.id=subject_ids, activity.id=activity_ids)
}


## CONSTANTS ##

# File locations
data_dir <- "./UCI HAR Dataset"
activity_labels_file <- file.path(data_dir, "activity_labels.txt")
feature_labels_file <- file.path(data_dir, "features.txt")
#folders <- c("test", "train")
folders <- c("dummy1", "dummy2") #smaller dataset for dev't


## MAIN ##

### Step 0: Download source data.

# Test if the data has been unzipped in the working directory...
if ( !all(file.exists(data_dir, activity_labels_file, feature_labels_file)) ) {
    # ... if not, download and unzip it
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile <- "./getdata_projectfiles_UCI HAR Dataset.zip"
    download.file(url, zipfile, method="curl")
    unzip(zipfile)
}

### Step 1: Merge the training and the test sets to create one data set.

# Load feature labels
feature_labels <- read.table(feature_labels_file, sep=" ", stringsAsFactors=FALSE)
feature_labels <- feature_labels[,2] #strip unnecessary first column of row numbers
#feature_labels <- sub("BodyBody","Body", feature_labels) #cleanup "BodyBody" labels

# Load and merge data
df <- data.frame()
for (folder in folders) {
    df <- rbind(df, getDataset(data_dir, folder, feature_labels))
}


### Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

# Drop columns which don't contain mean() or std() values (excepting activity.id & subject.id, of course)
df <- select( df, subject.id, activity.id, grep("(mean|std)\\.{2}", names(df)) )


### Step 3: Use descriptive activity names to name the activities in the data set.

# Load activity labels
activity_labels <- read.table(activity_labels_file, sep=" ", stringsAsFactors=FALSE)
activity_labels <- activity_labels[,2] #strip unnecessary first column of row numbers
activity_labels <- sub("_", " ", tolower(activity_labels)) #prettify

# Convert 'activity.id' column (numbers) to 'activity' (factors)
df$activity.id <- factor(df$activity.id, labels=activity_labels, ordered=FALSE)
names(df)[names(df)=="activity.id"] <- "activity" #rename column


### Step 4: Appropriately label the data set with descriptive variable names.

col_names <- names(df) #get a working copy of the column names

# Cleanup redundant "BodyBody" labels
col_names <- sub("BodyBody","Body", col_names)

# Expand the initial letters "t" and "f" for clarity
col_names <- sub("^t", "time", col_names)
col_names <- sub("^f", "freq", col_names)

# Move "mean" or "std" to the tail end of the word if there's an X/Y/Z axis
#   e.g. converts "timeBodyAccJerk.mean...X" into "timeBodyAccJerkX.mean"
col_names <- sub("(\\w+)\\.+(\\w+)\\.+([XYZ])", "\\1\\3.\\2", col_names)

# Convert tailing ".mean"/".std" or ".mean.." to "_mean"
col_names <- sub("(\\w+)\\.(mean|std)\\.*", "\\1_\\2", col_names)

names(df) <- col_names #apply the name changes

# Move "mean" and "std" into their own column "calculation"
#TODO: cleanup and comment this section
df2 <- reshape(df, varying=3:68, sep="_", direction="long")
names(df2)[names(df2)=="time"] <- "calculation" #rename column
df2$id <- NULL #drop new "id" column
row.names(df2) <- NULL #drop unnecessary row names
attr(df2, "reshapeLong") <- NULL #drop reshape's metadata
df2$calculation <- as.factor(df2$calculation) #make "calculation" column into factor


### Step 5: From the data set in step 4, create a second, independent tidy data set
###   with the average of each variable for each activity and each subject.
# TODO
