#Load libraries
library(deepnet)
library(nnet)
library(tictoc)
library(caret)
#neural net with ESTF binned features
#Load data
 dat <- read.csv("../RDC-TDA-ALPHA-ESTF-features100-50.csv", header = T)
# dat <- read.csv("../RDC-TDA-ALPHA-ESTF-features200-50.csv", header = T)
# dat <- read.csv("../RDC-TDA-ALPHA-ESTF-features500-50.csv", header = T)
# dat <- read.csv("../RDC-TDA-RIPS20-ESTF-features40-20.csv", header = T)
# dat <- read.csv("../RDC-TDA-RIPS20-ESTF-features80-20.csv", header = T)
# dat <- read.csv("../RDC-TDA-RIPS20-ESTF-features200-20.csv", header = T)
dat <- dat[,-1]
#include class labels first ( augment one column to the n*n smat)
n_class1 <- 150#refers to A_B
n_class2 <- 150#refers to A
n_class3 <- 150# refers to B
labels <- c(rep(1,n_class1),rep(2,n_class2),rep(3,n_class3))
dat <- cbind((labels),dat)#add labels to first column
names(dat)[1] <- "classLab"
str(dat)
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

#Basic repeated Neutral Net- repeted to find the best set of weights with lowest cost
nn.rep <- function(rep, ...) { # ... means the function takes any number of arguments
  v.min <- Inf # initialize v.min
  for (r in 1:rep) { # repeat nnet
    nn.temp <- nnet(...) # fit the first nnet
    v.temp <- nn.temp$value # store the cost
    if (v.temp < v.min) { # choose better weights
      v.min <- v.temp
      nn.min <- nn.temp
    }
  }
  return(nn.min)
}

#2 hidden units
tic()
dat.nn.rep <- nn.rep(rep = 30, train.dat$classLab ~ ., data = train.dat,
                        size = 2, linout = F, trace = FALSE, MaxNWts=10000 )
toc()

#4 hidden units
tic()
dat.nn.rep <- nn.rep(rep = 30, train.dat$classLab ~ ., data = train.dat,
                     size = 4, linout = F, trace = FALSE, MaxNWts=10000 )
toc()


#8 hidden units
tic()
fit3 <- nn.rep(rep = 30, classLab ~ ., data = training,
               size = 8, linout = F, trace = FALSE, MaxNWts=10000 )
toc()

#16 hidden units
tic()
fit4 <- nn.rep(rep = 30, classLab ~ ., data = training,
               size = 16, linout = F, trace = FALSE, MaxNWts=10000 )
toc()

#32 hidden units
# tic()
# fit5 <- nn.rep(rep = 30, classLab ~ ., data = training,
#                size = 32, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()

#predict using pseduo test data "testing"
pred1 <- predict(fit1, newdata=testing, type="class")
CM1 <- confusionMatrix(pred1, testing$classLab)
CM1

pred2 <- predict(fit2, newdata=testing, type="class")
CM2 <- confusionMatrix(pred2, testing$classLab)
CM2

pred3 <- predict(fit3, newdata=testing, type="class")
CM3 <- confusionMatrix(pred3, testing$classLab)
CM3

pred4 <- predict(fit4, newdata=testing, type="class")
CM4 <- confusionMatrix(pred4, testing$classLab)
CM4

pred5 <- predict(fit5, newdata=testing, type="class")
CM5 <- confusionMatrix(pred5, testing$classLab)
CM5

#retrain using full train data(training) and test on test data 
# Train on entire training set.
training <- data

#retrain using entire training datset with the best Parameter
best_unit <- 16
tic()
fit <- nn.rep(rep = 30, classLab ~ ., data = training,
              size = best_unit, linout = F, trace = FALSE, MaxNWts=10000 )
toc()
#predict using test data "test"
pred.test <- predict(fit, newdata=test, type="class")
CM <- confusionMatrix(pred.test, test$classLab)
CM

#Calculate %accuracy for each class:
acc_class1 <- sum(test.dat$classLab==1&dat.nn.pred==1)/30
acc_class1
acc_class2 <- sum(test.dat$classLab==2&dat.nn.pred==2)/30
acc_class2
acc_class3 <- sum(test.dat$classLab==3&dat.nn.pred==3)/30
acc_class3
mean(dat.nn.pred == test.dat$classLab)



