#Tree
#Load libraries
library(tree)
library(randomForest)
library(caret)
library(tictoc)
source("./ESTF_dataload.R")
#start training
mtry_val <- floor(sqrt(ncol(train.dat)-1))
tic()
set.seed(1)
rf.cls <- randomForest(classLab ~ .,
                       data = train.dat,
                       mtry = mtry_val,
                       ntree = 1000,
                       importance = TRUE)
toc()
#rf.cls
#importance(rf.cls)
varImpPlot(rf.cls)

#Bagging:
# tic()
# set.seed(1)
# bag.cls <- randomForest(classLab ~ .,
#                        data = train.dat,
#                        mtry = ncol(train.dat)-1, #m=p
#                        ntree = 100,
#                        importance = TRUE)
# toc()
# bag.imp <- importance(bag.cls)
# varImpPlot(bag.cls)


#Predict using test data
pred.cls.rf <- predict(rf.cls, newdata=test.dat, type = "class")
true.cls <- test.dat$classLab
CM <- confusionMatrix(pred.cls.rf,true.cls)
CM
