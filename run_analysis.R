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
