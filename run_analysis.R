library(reshape2)
library(plyr)

# load data files
testtable <- read.table("X_test.txt")
trainingtable<-read.table("X_train.txt")
featurestable <- read.table("features.txt")
activitylabelstable <- read.table("activity_labels.txt", col.names=c("id","activityname"))
trainingactivities <- read.table("y_train.txt")
testactivities <- read.table("y_test.txt")
trainingsubjects <- read.table("subject_train.txt")
testsubjects <- read.table("subject_test.txt")

#union the dataset, subject and activity tables together to make a single dataset
combinedtable <- rbind(testtable, trainingtable)
combinedsubjects <- rbind(testsubjects, trainingsubjects)
combinedactivities <- rbind(testactivities, trainingactivities)

#clean up the names in the features table to remove special characters (()- and make lower case

featurestable$V2 <- gsub("\\(|\\)|\\-|\\,","",featurestable$V2)
featurestable$V2 <- tolower(featurestable$V2)


#use key in "features.txt" to give the column names in dataset
names(combinedtable)<-featurestable$V2

#add the activity codes and subjects from the combined activities/subjects file
combinedtable <- cbind(combinedtable,combinedactivities)
combinedtable <- cbind(combinedtable,combinedsubjects)

colnames(combinedtable)[562:563] <- c("activitycode","subject")

#create a table that now only has mean and standar deviation values in
#we assume that features with "mean" in their name are means, and features with "std" in their name are standard deviations
meanstdtable<- combinedtable[,grep("mean|std|activitycode|subject",colnames(combinedtable))]

#add the textual description of the activity from the activity codes list
mergedtable <- merge(meanstdtable, activitylabelstable, by.x="activitycode", by.y="id")

#melt table to get 1 column for each value recorded
mergedtable <- melt(mergedtable, id=c("subject","activitycode","activityname"))

# process table to get 1 value showing the average of each variable for each activity for each subject
mergedtable <- ddply(mergedtable,.(variable, activityname, activitycode, subject), summarise, mean=mean(value))
mergedtable <- dcast(mergedtable, activityname + activitycode + subject ~ variable, value.var="mean")

#output final data table
write.csv(mergedtable, file="tidyfile.txt")