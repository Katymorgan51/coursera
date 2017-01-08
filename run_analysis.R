
setwd('C:/Users/Katy/Documents/UCI HAR Dataset')
features = read.table("features.txt")

#Can merge later
activity_labels = read.table("activity_labels.txt")

setwd("test")

subject_test = read.table("subject_test.txt") 
subject_test$V1 <- as.factor(subject_test$V1)
Y_test = read.table("Y_test.txt")
Y_test$V1 <- as.factor(Y_test$V1)
X_test = read.table("X_test.txt")

setwd("..")
setwd("train")

#subject is person
subject_train = read.table("subject_train.txt") 
subject_train$V1 <- as.factor(subject_train$V1)

Y_train = read.table("Y_train.txt")
Y_train$V1 <- as.factor(Y_train$V1)
X_train = read.table("X_train.txt")

#stick names of features on test and train data
names(X_train) <- features$V2
names(X_test) <- features$V2

#stick lables and subject on test and train data 
test <- X_test
test$label <- Y_test$V1
test$subject <- subject_test$V1

train <- X_train
train$label <- Y_train$V1
train$subject <- subject_train$V1

#Make a data set with test and train
both <- rbind(test,train)

#Keep only variables that relate to means and sds

#This was definitely not the way to do it...
both2 <- both
both2[,461:502] <- NULL
both2[,382:502] <- NULL 
both2[,303:344] <- NULL
 
#If you select something that doesn't exist it returns 0, serious flaw
std_means <- select(both2, contains("std"), contains("mean"), contains("label"), contains("subject"))

#look through remaining variables
both3 <- both2[!names(both2) %in% names(std_means)]

#looks fine
#put activity lables on
names(activity_labels) <- c("label","activity")

std_means2 <- merge(std_means,activity_labels)
#create mean for each activity for each subject
#69 variables 10299 observations

#one obs per person and activity 30*subjects*6*atcivities
std_means3 <- aggregate(. ~subject + activity, std_means2, mean)  

