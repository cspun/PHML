#Tree
#Load libraries
library(tree)
library(caret)
#neural net with ESTF binned features
#Load data
dat <- read.csv("./RDC_TDA_RIPS20_FEATURES.csv",header=F)
dat <- read.csv("./RDC_TDA_ALPHA_FEATURES.csv", header = F)
#include class labels first ( augment one column to the n*n smat)
n_class1 <- 150#refers to A_B
n_class2 <- 150#refers to A
n_class3 <- 150# refers to B
labels <- c(rep(1,n_class1),rep(2,n_class2),rep(3,n_class3))
dat <- cbind((labels),dat)#add labels to first column
names(dat)[1] <- "classLab"
#str(dat)
#convert class labels to factor type!
dat$classLab <- as.factor(dat$classLab) 

#Data split
#20-80 split
set.seed(1)
tr_ind_AB<-sort(sample(1:150,120,replace=F))
tr_ind_A<-sort(sample(151:300,120,replace=F))
tr_ind_B<-sort(sample(301:450,120,replace = F))
tr_ind<-c(tr_ind_AB,tr_ind_A,tr_ind_B)#augment all the selected ind for Dtr
train.dat<-dat[tr_ind,]#gives a 360*nfeatures mat
test.dat<-dat[-(tr_ind),]# gives a 90*nfeatures mat
#start training
cls.tree <- tree(train.dat$classLab ~ ., train.dat)
summary(cls.tree)
#cls.tree
plot(cls.tree)
text(cls.tree)
#CV for tree
cv.cls.tree <- cv.tree(cls.tree, FUN = prune.misclass)
cv.cls.tree
plot(cv.cls.tree$size, cv.cls.tree$dev, type='b')
(min.cv.cls <- cv.cls.tree$size[which.min(cv.cls.tree$dev)])
#Prune + Predict
prune.cls.tree <- prune.tree(cls.tree, best = min.cv.cls)
cmed.pred <- predict(prune.cls.tree, newdata = test.dat, type = "class")
cmed.true <- test.dat$classLab
CM <- confusionMatrix(cmed.pred, cmed.true)
CM

#prune.tree
summary(prune.cls.tree)
plot(prune.cls.tree)
text(prune.cls.tree)
#Calculate %accuracy for each class:
# acc_class1 <- sum(test.dat$classLab==1&cmed.pred==1)/30
# acc_class1
# acc_class2 <- sum(test.dat$classLab==2&cmed.pred==2)/30
# acc_class2
# acc_class3 <- sum(test.dat$classLab==3&cmed.pred==3)/30
# acc_class3
# mean(cmed.pred == cmed.true)

