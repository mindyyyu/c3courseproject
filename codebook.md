Project Description
-------------------

This project aims to create a tidy data set containing purely the mean
and standard deviation of the selected features.

Study design and data processing
--------------------------------

### Collection of the raw data

The raw data was collected from 30 volunteers performing six activities
(walking, walking upstairs, walking downstairs, sitting, standding and
laying). 70% of the data from volunteers was selected as training data
and 30% as the test data.

Creating the tidy data file
---------------------------

### Guide to create the tidy data file

-   merge the training and test data sets

<!-- -->

    setwd("/Users/mmmin/desktop/coursera-coding/UCI HAR Dataset/train")
    temp <- list.files(pattern="*.txt")
    traindata <- lapply(temp, read.table)
    traindata <- as.data.frame(traindata)
    setwd("/Users/mmmin/desktop/coursera-coding/UCI HAR Dataset/test")
    temp <- list.files(pattern="*.txt")
    testdata <- lapply(temp, read.table)
    testdata <- as.data.frame(testdata)
    completedata <- rbind(testdata, traindata)

-   extract the mean and standard deviation data

<!-- -->

    setwd("/Users/mmmin/desktop/coursera-coding/UCI HAR Dataset")
    feature <- read.table("features.txt")
    meancol <- grep("mean()", feature$V2, value = FALSE)
    sdcol <- grep("std", feature$V2, value = FALSE)
    completedatav2 <- completedata[, c(1, 563, meancol, sdcol)]

-   name the activities in the second column

<!-- -->

    labels <- read.table("activity_labels.txt")
    number <- labels[, 1]
    activitylabel <- labels[, 2]
    completedatav2$V1.2 <- sapply(completedatav2$V1.2[ ], FUN = function(i) {completedatav2$V1.2[completedatav2$V1.2[i] == number[i]] <<- activitylabel[i]})

-   name the rest of the variables (rename the column)

<!-- -->

    variablename <- as.character(feature[c(meancol, sdcol), 2])
    variablename <- gsub("-", ".", variablename)
    variablename <- gsub("\\(|\\)", "", variablename)
    variablename <- c("subject", "activity", variablename)
    colnames(completedatav2) <- variablename

-   create the final tidy data set

<!-- -->

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    tidydata <- group_by_(completedatav2, .dots = c("subject", "activity"))
    finaldata <- summarise_all(tidydata, mean)
    write.table(finaldata, file = "tidy_data.txt", row.name = FALSE)

Description of the variables in the tidy\_data.txt file
-------------------------------------------------------

-   dimension of the dataset is 180 rows and 81 columns
-   the variables include: subject, activity, standard deviation and
    mean of the feature vectors(79 in total)

### subject

-   integer
-   1-30
-   each integer represents the volunteer who performed the activities

### activity

-   factor
-   walking, walking upstairs, walking downstairs, sitting, standing and
    laying
-   These are the activities each volunteer performed

### means and standard deviations (column 3 to 81)

-   numeric
-   each value is the average of the raw data in which the same
    volunteer performed same activity within the same column
