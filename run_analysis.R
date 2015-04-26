																	##Set the current working directory to be USC HAR Dataset
																	##If 'dplyr' package hasn't been installed on your machine yet, please install the same
																	##Refer to README.md file associated with this script for additional explanation on the below code.

																	##CODEBLOCK_1
library(dplyr)														##load dplyr package
setwd("test")														##set the working directory to 'test' i.e. where the txt files are
x <- read.table("subject_test.txt")									##Read subject_test file in to x
y <- read.table("X_test.txt")										##Read X_test file in to y	
z <- read.table("y_test.txt")										##Read y_test file in to z
colnames(z) <- "activity"											##Rename the column in z to activity before combining data set
colnames(x) <- "subject"											##Rename the column in x to subject before combining data set
testdata <- data.frame(cbind(x,y,z))								##Combine all test datasets in to 1.
setwd("../")														##Go up one directory to UCI HAR Dataset directory

																	##CODEBLOCK_2
setwd("train")														##set the working directory to 'train' i.e. where the txt files are
x <- read.table("subject_train.txt")								##Read subject_train file in to x
y <- read.table("X_train.txt")										##Read X_train file in to y	
z <- read.table("y_train.txt")										##Read y_train file in to z
colnames(z) <- "activity"											##Rename the column in z to activity before combining data set
colnames(x) <- "subject"											##Rename the column in x to subject before combining data set
traindata <- data.frame(cbind(x,y,z))								##Combine all train datasets in to 1
masterdata <- data.frame(rbind(testdata,traindata)) 				##Combine the test and train datasets in one master
setwd("../")														##Go up one directory to UCI HAR Dataset directory

																	##CODEBLOCK_3
features <- read.table("features.txt")								##Read all 561 features in to the variable features
features$order <- 2:562												##Introduce a column for storing order of variables
features$V2 <- as.character(features$V2)							##Convert feature names column to character
features[562,1] <- 562												##Insert a record for the variable name "activity"
features[562,2] <- "activity"										##Insert a record for the variable name "activity"
features[562,3] <- 563												##Insert a record for the variable name "activity"
features[563,1] <- 563												##Insert a record for the variable name "subject"
features[563,2] <- "subject"										##Insert a record for the variable name "subject"
features[563,3] <- 1												##Insert a record for the variable name "subject"	
features <- arrange(features,order)									##Arrange the features list of variables by column order
colnames(masterdata) <- features$V2									##Now the column names of masterdata can be renamed sequentially as V2 of features

																												##CODEBLOCK_4							
valid_column_names <- make.names(names=names(masterdata), unique=TRUE, allow_ = TRUE)							##Get a clean set of column names minus any invalid characters
names(masterdata) <- valid_column_names																			##Transfer the valid column names
masterdata_select <- select (.data = masterdata, subject, activity, contains ("mean"), contains("std"))			##Select only columns from masterdata that have "mean" or "std" in column names
																												##Also include columns 'subject' and 'activity'

																												##CODEBLOCK_5
masterdata_select$activity [masterdata_select$activity == 1] <- "Walking"										##Assign descriptive activity names to masterdata_select data frame
masterdata_select$activity [masterdata_select$activity == 2] <- "Walking Upstairs"								##Assign descriptive activity names to masterdata_select data frame
masterdata_select$activity [masterdata_select$activity == 3] <- "Walking Downstairs"							##Assign descriptive activity names to masterdata_select data frame
masterdata_select$activity [masterdata_select$activity == 4] <- "Sitting"										##Assign descriptive activity names to masterdata_select data frame
masterdata_select$activity [masterdata_select$activity == 5] <- "Standing"										##Assign descriptive activity names to masterdata_select data frame
masterdata_select$activity [masterdata_select$activity == 6] <- "Laying"										##Assign descriptive activity names to masterdata_select data frame

																												##CODEBLOCK_6
tidydata_averages <- masterdata_select %>% group_by(subject,activity) %>% summarise_each(funs(mean))			##create groups based on a combination of subject and activity
write.table(tidydata_averages,file="tidydata_averages.txt", row.names=FALSE)									##Write file in to working directory
