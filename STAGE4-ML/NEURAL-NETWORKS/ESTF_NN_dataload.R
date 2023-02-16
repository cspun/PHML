#Load libraries
library(nnet)
library(deepnet)
library(caret)
library(data.table)

#neural net with ESTF binned features
#Load data
# dat <- read.csv("../RDC-TDA-AB-FULL-ALPHA-ESTF-features100-50.csv", header = T)
dat <- read.csv("../RDC-TDA-AB-FULL-ALPHA-ESTF-features200-50.csv", header = T)
# dat <- read.csv("../RDC-TDA-AB-FULL-ALPHA-ESTF-features500-50.csv", header = T)
# dat <- read.csv("../RDC-TDA-AB-FULL-RIPS20-ESTF-features40-20.csv", header = T)
# dat <- read.csv("../RDC-TDA-AB-FULL-RIPS20-ESTF-features80-20.csv", header = T)
# dat <- read.csv("../RDC-TDA-AB-FULL-RIPS20-ESTF-features200-20.csv", header = T)
dat <- dat[,-1]
#include class labels first ( augment one column to the n*n smat)
n_class1 <- 300#refers to A_B
n_class2 <- 300#refers to A
n_class3 <- 300# refers to B
labels <- c(rep(1,n_class1),rep(2,n_class2),rep(3,n_class3))
dat <- cbind((labels),dat)#add labels to first column
names(dat)[1] <- "classLab"
#str(dat)
#convert class labels to factor type!
dat$classLab <- as.factor(dat$classLab) 


#Data split
#20-80 split
set.seed(1)
tr_ind_AB<-sort(sample(1:300,240,replace=F))
tr_ind_A<-sort(sample(301:600,240,replace=F))
tr_ind_B<-sort(sample(601:900,240,replace = F))
tr_ind<-c(tr_ind_AB,tr_ind_A,tr_ind_B)#augment all the selected ind for Dtr
train.dat<-dat[tr_ind,]#gives a 360*nfeatures mat
test.dat<-dat[-(tr_ind),]# gives a 90*nfeatures mat


# Remove columns with near zero variance.
# nzv <- nearZeroVar(data)
# dat <- dat[,-nzr]
# 
# #compute the mean and sd of the TRAINING sets input
# (dat.mean <- apply(dat[tr_ind, -1], 2, mean))
# (dat.sd <- apply(dat[tr_ind, -1], 2, sd))
# # standardization (x - center) / scale
# dat.scaled <- data.frame(classLab = dat[1],scale(x = dat[-1],
#                                                  center = dat.mean,
#                                                  scale = dat.sd)
# )
# dat.train <- dat.scaled[tr_ind, ]
# dat.test <- dat.scaled[-tr_ind, ]