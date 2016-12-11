require(dplyr)

run_analysis <- function(){
    
    ################################################################################
    # Loading the data 
    # If the "UCI HAR Dataset" doesn't exist in the working directory, downloads the  
    # zip file and extracts its content
    ################################################################################
    if(!file.exists("./UCI HAR Dataset")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,destfile="UCI HAR Dataset.zip", mode="wb")
        unzip ("UCI HAR Dataset.zip")
    }
    
    
    ################################################################################
    # Reading activity_labels.txt file 
    # Read the class labels with their activity name and create a data frame with 
    # "ActivityID" and "ActivityName" columns
    ################################################################################
    activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                                 stringsAsFactors=FALSE, 
                                 col.names=c("ActivityID", "ActivityName"))
    
    
    ################################################################################
    # Reading features.txt file
    # Read the feature names and create a data frame with "featureID" and 
    # "featureName" columns
    # Delete the brackets and substitute the hyphen character ("-") for underscore 
    # character ("_") 
    ################################################################################
    featureLabels <- read.table("./UCI HAR Dataset/features.txt", 
                                stringsAsFactors=FALSE, 
                                col.names=c("featureID", "featureName"))
    featureLabels$featureName <- gsub( "\\(\\)","",featureLabels$featureName)
    featureLabels$featureName <- gsub( "-","_",featureLabels$featureName)
    
    
    ################################################################################
    # Read the y_test.txt files and converts the numeric value of the activity by 
    # its activity name
    ################################################################################
    activitiesTest <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                                 col.names="Activity")
    activitiesTest$Activity <- factor(activitiesTest$Activity, 
                                      levels=activityLabels$ActivityID, 
                                      labels=activityLabels$ActivityName)
    #
    activitiesTraining <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                                     col.names="Activity")
    activitiesTraining$Activity <- factor(activitiesTraining$Activity, 
                                          levels=activityLabels$ActivityID, 
                                          labels=activityLabels$ActivityName)
    
    
    ################################################################################
    # Read the subject_test.txt files
    ################################################################################
    subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                              col.names="SubjectID")
    #
    subjectTraining <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                                  col.names="SubjectID")
    
    
    ################################################################################
    # Read the X_test.txt files
    ################################################################################
    dataTest <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                           col.names=featureLabels$featureName)
    #
    dataTraining <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                               col.names=featureLabels$featureName)
    
    
    ################################################################################
    # For each type of data (test and training), generates a data frame with the 
    # required columns and properly labeled  
    ################################################################################
    testTable <- data.frame(dataType="Test", SubjectID=subjectTest$SubjectID, 
                            Activity=activitiesTest$Activity,
                            dataTest[,grepl("_mean_|_mean$|_std_|_std", featureLabels$featureName)])
    #
    trainingTable <- data.frame(dataType="Training", SubjectID=subjectTraining$SubjectID, 
                            Activity=activitiesTraining$Activity,
                            dataTraining[,grepl("_mean_|_mean$|_std_|_std", featureLabels$featureName)])
    
    
    ################################################################################
    # Generate a data frane with test and training data put together
    # Write the merged table to tydyDataset.txt file
    ################################################################################
    totalTable <- rbind(testTable, trainingTable)
    if(!file.exists("./output")){dir.create("./output")}
    write.table(totalTable, file="./output/all_in_one_Dataset.txt",row.names=FALSE)
    
    
    ################################################################################
    # Group the data from Activity and SubjectID columns
    # Generate a data set called summariseDataset.txt with the average of each
    # numeric column
    ################################################################################
    groupedTable <- group_by(totalTable, Activity, SubjectID)
    summariseTable <- summarise_each(groupedTable, funs(mean), -dataType)
    write.table(summariseTable, file="./output/averages_Dataset.txt",row.names=FALSE)
}
