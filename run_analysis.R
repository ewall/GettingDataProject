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
#TODO?: if not exist, download & extract the files?


## MAIN ##

### Step 1: Merge the training and the test sets to create one data set.

# Load feature labels
feature_labels <- read.table(feature_labels_file, sep=" ", stringsAsFactors=FALSE)
feature_labels <- feature_labels[,2] #strip unnecessary first column of row numbers
feature_lables <- sub("BodyBody","Body", feature_labels) #cleanup "BodyBody" labels

# Load and merge data
df <- data.frame()
for (folder in folders) {
    df <- rbind(df, getDataset(data_dir, folder, feature_labels))
}


### Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

# Drop columns which don't contain mean(), std(), or meanFreq() values (excepting activity.id & subject.id, of course)
df <- select(df, subject.id, activity.id, grep("[Mm]ean|std", names(df)))


### Step 3: Use descriptive activity names to name the activities in the data set.

# Load activity labels
activity_labels <- read.table(activity_labels_file, sep=" ", stringsAsFactors=FALSE)
activity_labels <- activity_labels[,2] #strip unnecessary first column of row numbers
activity_labels <- sub("_", " ", tolower(activity_labels)) #prettify

# Convert 'activity.id' column (numbers) to 'activity' (factors)
df$activity.id <- factor(df$activity.id, labels=activity_labels, ordered=FALSE)
names(df)[names(df)=="activity.id"] <- "activity" #rename column


### Step 4: Appropriately label the data set with descriptive variable names.

