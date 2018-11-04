####merge the training and the test sets
setwd("/Users/mmmin/desktop/coursera-coding/UCI HAR Dataset/train")
temp <- list.files(pattern="*.txt")
traindata <- lapply(temp, read.table)
traindata <- as.data.frame(traindata)
setwd("/Users/mmmin/desktop/coursera-coding/UCI HAR Dataset/test")
temp <- list.files(pattern="*.txt")
testdata <- lapply(temp, read.table)
testdata <- as.data.frame(testdata)
completedata <- rbind(testdata, traindata)

####Extracts only mean and sd
setwd("/Users/mmmin/desktop/coursera-coding/UCI HAR Dataset")
feature <- read.table("features.txt")
meancol <- grep("mean()", feature$V2, value = FALSE)
sdcol <- grep("std", feature$V2, value = FALSE)
completedatav2 <- completedata[, c(562:563, meancol, sdcol)]

#####name the activities
labels <- read.table("activity_labels.txt")
number <- labels[, 1]
activitylabel <- labels[, 2]
completedatav2$V1.2 <- sapply(completedatav2$V1.2[ ], FUN = function(i) {completedatav2$V1.2[completedatav2$V1.2[i] == number[i]] <<- activitylabel[i]})

######name the variables
variablename <- as.character(feature[c(meancol, sdcol), 2])
variablename <- gsub("-", ".", variablename)
variablename <- gsub("\\(|\\)", "", variablename)
variablename <- c("subject", "activity", variablename)
colnames(completedatav2) <- variablename

#####create new data set
library(dplyr)
tidydata <- group_by_(completedatav2, .dots = c("subject", "activity"))
finaldata <- summarise_all(tidydata, mean)
write.table(finaldata, file = "tidy_data.txt", row.name = FALSE)




