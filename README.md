# Course Project - Eric Wallace
## from Coursera's [Getting and Cleaning Data](https://class.coursera.org/getdata-007/)

[Details & Instructions](https://class.coursera.org/getdata-007/human_grading/view/courses/972585/assessments/3)

Given [this data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) as [described here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), the R script `run_analysis.R` should do the following: 

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set.
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

---

This script was created on [R version 3.1.1](http://www.r-project.org/) and requires only the [dplyr package](http://cran.r-project.org/web/packages/dplyr/) and its dependencies in addition to the standard library.

I'll describe the choices I've made and procedures to do them step-wise.

### Step 0) Download source data.

I've added this step for convenience.

The script expects the source data to be unzipped in the working directory with the default name "UCI HAR Dataset". If it doesn't find the expected files, it will download the file and unzip it in the working directory.

### Step 1) Merge the training and the test sets to create one data set.

The source data contains two directories, "test" and "train", which each contain 3 files compositing the dataset:

- the bulk of the data (the signal observations) are found in `X_<foldername>.txt`
- a column of subject id's are found in `subject_<foldername>.txt`
- a column of activity id's are found in `y_<foldername>`.txt

Each file contains the same number of lines/rows and are ordered accordingly, so they essentially fit together in one way. David Hood, a Community TA for the class, sketched up the following diagram which visualizes the fit quite nicely (Hood, 2014):

![data diagram](https://coursera-forum-screenshots.s3.amazonaws.com/ab/a2776024af11e4a69d5576f8bc8459/Slide2.png)

### Step 2) Extract only the measurements on the mean and standard deviation for each measurement. 

The source data set, as described in `features_info.txt`, includes quite a few calculations for each measured signal, including the mean, standard deviation, min/max, correlation, etc.

I am taking a literal interpretation of the assignment's description, so I retain only the columns with mean() and std() values, excluding the mean frequency values. This also necessarily excludes the angle() values which, though they operate on some of the mean-value data, are not mean values in themselves.

### Step 3) Use descriptive activity names to name the activities in the data set.

The source data loaded earlier in the program contained activity id's (integers 1 through 6), which are given text values in the `activity_labels.txt` file. Here I load those values and make the activity column of my dataset into a factor with the text labels.

### Step 4) Appropriately label the data set with descriptive variable names. 

For the most part, I choose to keep the signal labels described in the source data's `features_info.txt` file, with the following changes:

- The initial character of 't' or 'f' are difficult to distinguish at a glance, so I have expanded these into the full names of 'time' and 'freq' respectively, since they are time and frequency domain signals.
- Some of the signal names given in the source `features.txt` labels erroneously duplicate the 'Body' term as 'BodyBody', so I have corrected these column names.
- Since R does not accept dashes in the row names, I have substituted underscores when the signal is specific to the X, Y, or Z axis.
- As described in the next step, I split out the signal and calculation names.

### Step 4b) Move "mean" and "std" into their own column "calculation".

I've added this as another "step" since I feel it's important to tidying the data but it is not necessarily covered in the tasks' step descriptions.

At this point in the script, we have separate columns for each signal's mean and standard deviation calculations, e.g. "timeBodyAccX^mean" and "timeBodyAccX^std", across 66 of the 68 columns. In an effort towards tidier data as described in Wickham (2014), I have "melted" the mean and standard deviation values into their own column named "calculation", such that each signal like "timeBodyAccX" will have two rows, one for the mean and another for the standard deviation. The doubles the number of rows and nearly halves the number of signal columns (33 signals plus activity, subject_id, and calculation total to 36), making the data set "longer".

### Step 5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

R and its various standard and add-on libraries provide many different ways one could calculate the means of the grouped data. Here I have used the dplyr library for simplicity, but it could be done with R's built-in `aggregate()` function just as easily (as shown in the code comments).

The resultant data (a table of means grouped for each activity, subject, and calculation) is then saved to the file `tidy_averages.txt` in the working directory.

Please see my `Codebook.md` file for details on the fields in the output dataset.

## References

- Hood, David. "Re: David's project FAQ." 12 Sep 2014. Coursera, Online Posting to Course Project. Web. 20 Sep. 2014. <https://class.coursera.org/getdata-007/forum/thread?thread_id=49>

- Wickham, Hadley. "Tidy Data." Journal of Statistical Software 59.10 (2014): 23 pages. Web. 20 Sep. 2014. <http://www.jstatsoft.org/v59/i10/paper>