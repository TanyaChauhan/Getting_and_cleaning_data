if(!file.exists("week4assignment"))
{
  dir.create("week4assignment")
}
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="week4assignment/run_analysis",mode = "wb")
list.files("week4assignment/run_analysis")
unzip("week4assignment/run_analysis",exdir="week4assignment")
list.files("week4assignment")
pathdata = file.path("./week4assignment", "UCI HAR Dataset")
files = list.files(pathdata, recursive=TRUE)
files
#Reading training tables - xtrain / ytrain, subject train
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)
#Providing column names to train dataset
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Providing column names to test dataset
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Providing column names to activityLabels dataset
colnames(activityLabels) <- c('activityId','activityType')
#Merging 
mergetrain = cbind(ytrain, subject_train, xtrain)
mergetest = cbind(ytest, subject_test, xtest)
merged_dataset = rbind(mergetrain, mergetest)
colNames = colnames(merged_dataset)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- merged_dataset[ , mean_and_std == TRUE]
#descriptive names 
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)
#New Tidy Dataset
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
#The last step is to write the ouput to a text file 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)