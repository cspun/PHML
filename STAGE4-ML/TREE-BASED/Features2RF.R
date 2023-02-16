#Tree
#Load libraries
library(tree)
library(randomForest)
library(caret)
library(tictoc)
source("./Features_dataload.R")
#start training
mtry_val <- floor(sqrt(ncol(train.dat)-1))
tic()
set.seed(1)
# rf.cls <- randomForest(classLab ~ .,
#                        data = train.dat,
#                        mtry = mtry_val,
#                        ntree = 100,
#                        importance = TRUE)
# rf.cls <- randomForest(classLab ~ .,
#                        data = train.dat,
#                        mtry = mtry_val,
#                        ntree = 501,
#                        importance = TRUE)
rf.cls <- randomForest(classLab ~ .,
                       data = train.dat,
                       mtry = mtry_val,
                       ntree = 1000,
                       importance = TRUE)
toc()
#rf.cls
importance(rf.cls)
varImpPlot(rf.cls)
plot(rf.cls, main = "Plot of error rates against ntrees used for RF")
legend("topright",pch=4,col=1:4,legend=c("OOB error","Class 1 error","Class 2 error","Class 3 error"))
pruned_min <- min(which(rf.cls$err.rate[,1]==min(rf.cls$err.rate[,1])))
pruned_min
#Predict using test data
pred.cls.rf <- predict(rf.cls, newdata=test.dat, type = "class")
true.cls <- test.dat$classLab
CM <- confusionMatrix(pred.cls.rf,true.cls)
CM

#IN SAMPLE:
predtrain<- predict(rf.cls, newdata=train.dat, type = "class")
confusionMatrix(predtrain,train.dat$classLab)
#varimp
colnames(importance(rf.cls))
sort(importance(rf.cls)[,4],decreasing = T)[1:12] #sorted based on "MeanDecreaseAccuracy"
sort(importance(rf.cls)[,5],decreasing = T)[1:12] #sorted based on "MeanDecreaseGini" 

#pruned
rf.cls2 <- randomForest(classLab ~ .,
                       data = train.dat,
                       mtry = mtry_val,
                       ntree = pruned_min,
                       importance = TRUE)
pred.cls.rf2 <- predict(rf.cls2, newdata=test.dat, type = "class")
true.cls <- test.dat$classLab
CM2 <- confusionMatrix(pred.cls.rf2,true.cls)
CM2
