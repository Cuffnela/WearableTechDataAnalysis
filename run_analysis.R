################################################################################
##                                                                            ##
## Laurie Cuffney                                                             ##
## 7/11/2019                                                                  ## 
## Coursera Data Science; Johns Hopkins                                       ##
##                                                                            ##
## This program analyses data collected from Samsung Galaxy S smartphone      ##
## accelerometers.                                                            ##
##                                                                            ##
################################################################################

# load packages
library(stringr)
library(reshape2)
library(dplyr)

################################################################################
## test data manipulation                                                     ##
################################################################################

################################################################################
## addresses and read in of files                                             ##
################################################################################
# internal addresses to data files
testXAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/test/X_test.txt"
testYAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/test/y_test.txt"
testSubAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/test/subject_test.txt"
featuresAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/features.txt"

# load in text file data
testX<-read.table(testXAddress, header = FALSE)
testY<-read.delim(testYAddress, header = FALSE)
testSub<-read.delim(testSubAddress, header = FALSE)
features<-read.delim(featuresAddress, header = FALSE)

################################################################################
## clean up variable names and make sure columns are named readably           ##
################################################################################
# function to remove leading numbers
numRemove<-function(x){
    x<-sub("^[0-9]* ", "", x)
}
# remove numbers from features
feat<-sapply(features,numRemove)

# assign variable names to each dataframe
names(testSub)<-c("SubjectID")
names(testY)<-c("Activity")
names(testX)<- feat

################################################################################
## This function converts Activity IDs to readable activity names             ##
################################################################################

# list of activities names ordered by their ID number from original codebook
activities<-c("walking", "walkingUpstairs", "walkingDownstairs", "sitting", 
              "standing","laying")
# define rename function that uses previous vector
renameAct<-function(x){
    x<-activities[x]
}
# apply rename function to activity data to create a readable list
testYreadable<-sapply(testY,renameAct)


################################################################################
## Extract only the measurements for the mean and standard deviations for each##
## measurement                                                                ##
################################################################################
# find indices of means (mean) and standard deviations (std) in the features 
# columns of testX
locationMeanStd<-grep("mean\\(\\)|std\\(\\)", feat)
testXMeanStd<-testX[,locationMeanStd]

################################################################################
# combined test data                                                          ##
################################################################################
testData<-cbind(testSub, testYreadable, testXMeanStd)


################################################################################
## training data manipulation                                                 ##
################################################################################

################################################################################
## addresses and read in of files                                             ##
################################################################################
# internal addresses to data files
trainXAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/train/X_train.txt"
trainYAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/train/y_train.txt"
trainSubAddress<-"C:/Users/cuffn/Documents/Code/Coursera-DataScience/WearableTechDataAnalysis/UCI_HAR_Dataset/train/subject_train.txt"

# load in text file data
trainX<-read.table(trainXAddress, header = FALSE)
trainY<-read.delim(trainYAddress, header = FALSE)
trainSub<-read.delim(trainSubAddress, header = FALSE)

################################################################################
## make sure columns are named and variables are readable                     ##
################################################################################
# assign variable names to each dataframe
names(trainSub)<-c("SubjectID")
names(trainY)<-c("Activity")
names(trainX)<- feat

# apply rename function to activity data to create a readable list
trainYreadable<-sapply(trainY,renameAct)

################################################################################
# combined train data                                                          ##
################################################################################
# pull only mean and std data
trainXMeanStd<-trainX[,locationMeanStd]

trainData<-cbind(trainSub, trainYreadable, trainXMeanStd)


################################################################################
## merge train and test data                                                  ##
################################################################################
fullData<-merge(trainData,testData, all=TRUE)

################################################################################
## find averages of each variable by subject ID and activity                  ##
################################################################################
# melt data to make skinny data to make dcast possible for all 
# variables of interest
skinnyData<-melt(fullData,id=c("SubjectID","Activity"),
                 measure.vars=names(trainXMeanStd))

# use dcast to average all 66 mean and standard deviation variables by subject
# and activity
averageData<-dcast(skinnyData, SubjectID + Activity ~ variable, mean)


# arrange data by activity and subject ID 
finaldata<-dplyr::arrange(averageData,Activity,SubjectID)

# write final tidy data into txt file
write.table(finaldata, "tidydata.txt", append = FALSE, sep = " ", dec = ".",
            row.names = TRUE, col.names = TRUE)
