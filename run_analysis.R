# Getting and Cleaning Data - Course Project

# File locations
data_dir <- "./UCI HAR Dataset"
activity_labels_file <- file.path(data_dir, "activity_labels.txt")
feature_labels_file <- file.path(data_dir, "features.txt")
folders <- c("test", "train")

# Load activity labels
activity_labels <- read.table(activity_labels_file, sep=" ", stringsAsFactors=FALSE)
activity_labels <- activity_labels[,2] #strip unnecessary first column of row numbers
#activity_factors <- gl(length(activity_labels), 1, labels=activity_labels)

# Load feature labels
feature_labels <- read.table(feature_labels_file, sep=" ", stringsAsFactors=FALSE)
feature_labels <- feature_labels[,2] #strip unnecessary first column of row numbers

# Load and merge data
df <- data.frame()
for (folder in folders) {

    # Get main data set
    #   file: X_<folder>.txt = data set
    data_file <- paste(data_dir, "/", folder, "/", "X_", folder, ".txt", sep="")
    data <- read.fwf(data_file,
                     widths=c(-1, rep(16, times=length(feature_labels))),
                     col.names=feature_labels,
                     stringsAsFactors=FALSE)

    # Get subject_id column
    #   file: subject_<folder>.txt = 1 column: subject_id
    subjects_file <- paste(data_dir, "/", folder, "/", "subject_", folder, ".txt", sep="")
    subjects <- read.table(subjects_file)[[1]] #return just a vector

    # Get activity column
    #   file: y_<folder>.txt = 1 column: activity (factors)
    activities_file <- paste(data_dir, "/", folder, "/", "y_", folder, ".txt", sep="")
    activities <- read.table(activities_file)[[1]] #return just a vector
    #   convert numbers to factors
    activities <- factor(activities, labels=activity_labels, ordered=FALSE)

    # Check number of rows match for all 3 input files
    if (nrow(data) != length(subjects)) stop("input files row counts not equal")
    if (length(subjects) != length(activities)) stop("input files row counts not equal")

    # Glom on the columns
    data <- cbind(subject.id=subjects, activity=activities, data)

    # Merge into data frame
    df <- rbind(df, data)
}