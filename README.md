# README Get and Clean Data Project---
---

This Read Me file describes variables, data, and transformations from the original Samsung Galaxy S data set described below.

R code
======================================
This was the R code used to create the new data set. The comments provide more detail to what the code is doing.

```{r}
library(plyr)
library(reshape2)

## Set the original directory
original.wd = getwd()

## Find a folder that contains "UCI HAR Dataset" in the original directory. If exactly one is found
## then set the directory to this folder. Done to lessen chance of importing a wrong data set of the
## names as below
find.folder = dir(original.wd, pattern = "UCI HAR Dataset", full.names = TRUE)
if (length(find.folder)==1) {
  setwd(find.folder)
}

## Read in the exact files needed, cbind test then train data, rbind to make one data set
activity_labels <- read.table(list.files(pattern = "^activity_labels\\.txt$",recursive=TRUE))
features <- read.table(list.files(pattern = "^features\\.txt$",recursive=TRUE))

test.data <-cbind(read.table(list.files(pattern = "^subject_test\\.txt$",recursive=TRUE)),
                   read.table(list.files(pattern = "^X_test\\.txt$",recursive=TRUE)),
                   read.table(list.files(pattern = "^y_test\\.txt$",recursive=TRUE)))

train.data <-cbind(read.table(list.files(pattern = "^subject_train\\.txt$",recursive=TRUE)),
                   read.table(list.files(pattern = "^X_train\\.txt$",recursive=TRUE)),
                   read.table(list.files(pattern = "^y_train\\.txt$",recursive=TRUE)))

complete.data = rbind(train.data,test.data)

## Get and set variable names, join on common name, and remove unwanted column
feature.names = as.character(features$V2)
names(complete.data) = c("subject",feature.names,"y")
names(activity_labels) = c("y","activity")
complete.data = join(complete.data,activity_labels,by="y")
complete.data$y = NULL

## Select mean and std columns
mean.sd.index = c(grep("mean()",names(complete.data)),grep("std()",names(complete.data)))
mean.sd.data = cbind(complete.data[,c("subject","activity")],complete.data[,mean.sd.index])
mean.sd.data$subject = as.factor(mean.sd.data$subject)

## Use melt to create the final data frame containing the desired averages, then write the file
final.data = dcast(melt(mean.sd.data,id = c("subject","activity")),subject+activity~variable,mean)

write.table(final.data,file = paste(original.wd,"/clean_data_project.txt",sep=""), row.names = FALSE,col.names = TRUE,sep="\t")

```
Previous Data Section
======================================

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit?? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
