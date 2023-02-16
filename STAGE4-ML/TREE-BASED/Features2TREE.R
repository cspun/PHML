#Tree
#Load libraries
library(tree)
library(caret)
#neural net with ESTF binned features
source("./Features_dataload.R")
#start training
cls.tree <- tree(train.dat$classLab ~ .-train.dat$classLab , train.dat)
summary(cls.tree)
cls.tree
#plot(cls.tree)
#text(cls.tree)
#CV for tree
cv.cls.tree <- cv.tree(cls.tree, FUN = prune.misclass)
cv.cls.tree
plot(cv.cls.tree$size, cv.cls.tree$dev, type='b')
(min.cv.cls <- cv.cls.tree$size[which.min(cv.cls.tree$dev)])
#Prune + Predict
prune.cls.tree <- prune.tree(cls.tree, best = min.cv.cls)
plot(prune.cls.tree)
text(prune.cls.tree)
cmed.pred <- predict(prune.cls.tree, newdata = test.dat, type = "class")
cmed.true <- test.dat$classLab
CM <- confusionMatrix(cmed.pred, cmed.true)
CM


