#CodeBook
##Original data

The data to be cleaned comes from the experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

For more information about the experiment, you can visit the following page:
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

All the information are zipped in a file called "UCI HAR Dataset.zip" and you can download it from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. This file contains the following structure:

    UCI HAR Dataset
        |-- test
        |    |-- Inertial Signals
        |    |    |-- body_acc_x_test.txt
        |    |    |-- body_acc_y_test.txt
        |    |    |-- body_acc_z_test.txt
        |    |    |-- body_gyro_x_test.txt
        |    |    |-- body_gyro_y_test.txt
        |    |    |-- body_gyro_z_test.txt
        |    |    |-- total_acc_x_test.txt
        |    |    |-- total_acc_y_test.txt
        |    |    └-- total_acc_z_test.txt  
        |    |-- subject_test.txt
        |    |-- X_test.txt
        |    └-- y_test.txt
        |-- train
        |    |-- Inertial Signals
        |    |    |-- body_acc_x_train.txt
        |    |    |-- body_acc_y_train.txt
        |    |    |-- body_acc_z_train.txt
        |    |    |-- body_gyro_x_train.txt
        |    |    |-- body_gyro_y_train.txt
        |    |    |-- body_gyro_z_train.txt
        |    |    |-- total_acc_x_train.txt
        |    |    |-- total_acc_y_train.txt
        |    |    └-- total_acc_z_train.txt 
        |    |-- subject_train.txt
        |    |-- X_train.txt
        |    └-- y_train.txt
        |-- activity_labels.txt
        |-- features.txt
        |-- features_info.txt
        └-- README.txt
        
Only the following files will be processed in this project:

- **activity_labels.txt**: Links the class labels with their activity name and has the following content:
```
    1 WALKING
    2 WALKING_UPSTAIRS
    3 WALKING_DOWNSTAIRS
    4 SITTING
    5 STANDING
    6 LAYING
```
- **features.txt**: List of all features. Contains the name of 561 features that are recorded in X_test.txt and X_train.txt files:
```
    1 tBodyAcc-mean()-X
    2 tBodyAcc-mean()-Y
    ...
    560 angle(Y,gravityMean)
    561 angle(Z,gravityMean)
```
- **subject_test.txt/subject_train.txt**: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- **X_test.txt/X_train.txt**: Each row is a vector of 561 features.

- **y_test.txt/y_train.txt**: Each row indicates the type of activity measured in each row in files **X_test.txt/X_train.txt** respectively.

##Transformation process
The following is a description of the steps taken to process the information and to obtain the file with the final result requested in the project.

- The process starts downloading and unzipping the "UCI HAR Dataset.zip" file. First of all, it verifies if the "UCI HAR Datase" directory exists in the working directory. If so, the file will not be downloaded. That way, you can repeat the process without spending time downloading the same file at each iteration.

- Reads the **activity_labels.txt** file and generates a data.frame called **activityLabels** with the following structure:
```
      ActivityID       ActivityName
               1            WALKING
               2   WALKING_UPSTAIRS
               3 WALKING_DOWNSTAIRS
               4            SITTING
               5           STANDING
               6             LAYING
```
- Reads the **features.txt** file and generates a data.frame called **featureLabels**. The name of each feature presents parentheses and hyphens characters. The parentheses are deleted and the hyphens are replaced by underscore characters. For example, "tBodyAcc-mean()-X" is transformed in "tBodyAcc_mean_X". As a result, you get the following data.frame:
```
      featureID     featureName
              1 tBodyAcc_mean_X
              2 tBodyAcc_mean_Y
              3 tBodyAcc_mean_Z
      ...
            560 angle(Y,gravityMean)
            561 angle(Z,gravityMean)
```
- Reads the **y_test.txt** file and converts the numeric value of the activity by its activity name using the **activityLabels** data.frame. The information is stored in the **activitiesTest** data.frame with the following structure:
```
      Activity
      STANDING
      STANDING
      STANDING
    ...
      WALKING_UPSTAIRS
      WALKING_UPSTAIRS
      WALKING_UPSTAIRS
```
- The same treatment described in the previous point is done for the **y_train.txt** file.

- Reads the **subject_test.txt** and **subject_train.txt** and stores its content in a data.frame called **subjectTest** and **subjectTraining** respectively.
