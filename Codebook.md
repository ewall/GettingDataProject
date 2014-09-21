# Course Project Codebook - Eric Wallace
## from Coursera's [Getting and Cleaning Data](https://class.coursera.org/getdata-007/)

### Description of the study:

All data comes from the Human Activity Recognition Using Smartphones Data Set provided by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, and Luca Oneto and is available online at <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> as accessed on 20 September 2014.

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. (Anguita et al, 2012)

### Sampling information:

> Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz...
>
> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. (Anguita et al, 2012)

The original data was divived into two sample groups labeled "test" and "train"; these have been merged for the purposes of this analysis.

### File details:

The data is provided as a single ASCII text file, `tidy_averages.txt`

The first line contains the column headers. Fields are deliniated by spaces. All text values are in double-quotes.

There are 360 rows of 36 variables.

### Data structure:

The 36 columns are labeled and comprised as follows. The first 3 columns are part of the grouping:

- *activity*: text factors of the 6 activities recorded: "walking", "walking upstairs", "walking downstairs", "sitting", "standing", and "laying"
- *subject_id*: integers 1 through 30, representing the test subjects
- *calculation*: text factors "mean" or "std" (standard deviation)

The remaining 33 columns show the **mean value** of measurements on that variable for the group by activity, subject, and calculation:

- *timeBodyAcc_X*: time domain signal of body acceleration on x-axis
- *timeBodyAcc_Y*: time domain signal of body acceleration on y-axis
- *timeBodyAcc_Z*: time domain signal of body acceleration on z-axis
- *timeGravityAcc_X*: time domain signal of gravity acceleration on x-axis
- *timeGravityAcc_Y*: time domain signal of gravity acceleration on y-axis
- *timeGravityAcc_Z*: time domain signal of gravity acceleration on z-axis
- *timeBodyAccJerk_X*: time domain signal of body acceleration jerk on x-axis
- *timeBodyAccJerk_Y*: time domain signal of body acceleration jerk on y-axis
- *timeBodyAccJerk_Z*: time domain signal of body acceleration jerk on z-axis
- *timeBodyGyro_X*: time domain signal of gyroscope on x-axis
- *timeBodyGyro_Y*: time domain signal of gyroscope on y-axis
- *timeBodyGyro_Z*: time domain signal of gyroscope on z-axis
- *timeBodyGyroJerk_X*: time domain signal of gyroscope jerk on x-axis
- *timeBodyGyroJerk_Y*: time domain signal of gyroscope jerk on y-axis
- *timeBodyGyroJerk_Z*: time domain signal of gyroscope jerk on z-axis
- *timeBodyAccMag*: time domain signal of body acceleration magnitude
- *timeGravityAccMag*: time domain signal of gravity acceleration magnitude
- *timeBodyAccJerkMag*: time domain signal of body acceleration jerk magnitude
- *timeBodyGyroMag*: time domain signal of gyroscope magnitude
- *timeBodyGyroJerkMag*: time domain signal of gryoscope jerk magnitude
- *freqBodyAcc_X*: frequency domain signal of body acceleration on x-axis
- *freqBodyAcc_Y*: frequency domain signal of body acceleration on y-axis
- *freqBodyAcc_Z*: frequency domain signal of body acceleration on z-axis
- *freqBodyAccJerk_X*: frequency domain signal of body acceleration jerk on x-axis
- *freqBodyAccJerk_Y*: frequency domain signal of body acceleration jerk on y-axis
- *freqBodyAccJerk_Z*: frequency domain signal of body acceleration jerk on z-axis
- *freqBodyGyro_X*: frequency domain signal of gyroscope on x-axis
- *freqBodyGyro_Y*: frequency domain signal of gyroscope on x-axis
- *freqBodyGyro_Z*: frequency domain signal of gyroscope on x-axis
- *freqBodyAccMag*: frequency domain signal of body acceleration 
- *freqBodyAccJerkMag*: frequency domain signal of gravity acceleration magnitude
- *freqBodyGyroMag*: frequency domain signal of body acceleration jerk magnitude
- *freqBodyGyroJerkMag*: frequency domain signal of gyroscope jerk magnitude

Please see the original study's `features_info.txt` file for more details on the signals and transformations.

## References

- Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
