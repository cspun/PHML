library(caret)
library(doParallel)
library(nnet)
library(tictoc)
registerDoParallel(cores = 4)
source("./Features_NN_dataload.R")
data <- train.dat
test <- test.dat
data$classLab <- as.factor((data$classLab))
dat.scaled$classLab <-as.factor((dat.scaled$classLab))
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

#Training neural networks with diff number of hidden units
#divide the training data called "data" into 4 parts, 3 parts to psuedo training index, 1 partto pseudo testing
# set.seed(1)
# inTrain <- createDataPartition(data$classLab, p = 3/4)[[1]]
# training <- data[inTrain,]
# testing <- data[-inTrain,]

# n_rep <- 30
# #2 hidden units
# tic()
# fit1<- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                      size = 2, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# 
# #4 hidden units
# tic()
# fit2 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                      size = 4, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# 
# #8 hidden units
# tic()
# fit3 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                size = 8, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# 
# #16 hidden units
# tic()
# fit4 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                size = 16, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# 
# #32 hidden units
# tic()
# fit5 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#              size = 32, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# 
# tic()
# fit6 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                size = 64, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# 
# tic()
# fit7 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                size = 128, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()#191.028 sec elapsed
# 
# tic()
# fit8 <- nn.rep(rep = n_rep, classLab ~ ., data = training,
#                size = 256, linout = F, trace = FALSE, MaxNWts=10000 )
# toc()
# # summary(fit1)
# # summary(fit2)
# # summary(fit3)
# # summary(fit4)
# 
# #Train on entire training set.
# training <- data
# 
# training and testing on same data: not insample error
# results1 <- predict(fit1, newdata=training, type="class")
# conf1 <- confusionMatrix(results1, training$classLab)
# conf1
# 
# results2 <- predict(fit2, newdata=training, type="class")
# conf2 <- confusionMatrix(results2, training$classLab)
# conf2
# 
# results3 <- predict(fit3, newdata=training, type="class")
# conf3 <- confusionMatrix(results3, training$classLab)
# conf3
# 
# results4 <- predict(fit4, newdata=training, type="class")
# conf4 <- confusionMatrix(results4, training$classLab)
# conf4
# 
# results5 <- predict(fit5, newdata=training, type="class")
# conf5 <- confusionMatrix(results5, training$classLab)
# conf5
# 
# results6 <- predict(fit6, newdata=training, type="class")
# conf6 <- confusionMatrix(results5, training$classLab)
# conf6
# 
# results7 <- predict(fit7, newdata=training, type="class")
# conf7 <- confusionMatrix(results5, training$classLab)
# conf7
# 
# results8 <- predict(fit8, newdata=training, type="class")
# conf8 <- confusionMatrix(results8, training$classLab)
# conf8


#predict using pseduo test data "testing"
# pred1 <- predict(fit1, newdata=testing, type="class")
# CM1 <- confusionMatrix(pred1, testing$classLab)
# CM1
# 
# pred2 <- predict(fit2, newdata=testing, type="class")
# CM2 <- confusionMatrix(pred2, testing$classLab)
# CM2
# 
# pred3 <- predict(fit3, newdata=testing, type="class")
# CM3 <- confusionMatrix(pred3, testing$classLab)
# CM3
# 
# pred4 <- predict(fit4, newdata=testing, type="class")
# CM4 <- confusionMatrix(pred4, testing$classLab)
# CM4
# 
# pred5 <- predict(fit5, newdata=testing, type="class")
# CM5 <- confusionMatrix(pred5, testing$classLab)
# CM5
# 
# pred6 <- predict(fit6, newdata=testing, type="class")
# CM6 <- confusionMatrix(pred6, testing$classLab)
# CM6
# 
# pred7 <- predict(fit6, newdata=testing, type="class")
# CM7 <- confusionMatrix(pred7, testing$classLab)
# CM7
# 
# pred8 <- predict(fit8, newdata=testing, type="class")
# CM8 <- confusionMatrix(pred8, testing$classLab)
# CM8
#retrain using full train data(training) and test on test data 
# Train on entire training set.
training <- data

#retrain using entire training datset with the best Parameter
best_unit <- 2^7
tic()
fit <- nn.rep(rep = 30, classLab ~ ., data = training,
              size = best_unit, linout = F, trace = FALSE, MaxNWts=100000 )
toc()
#predict using test data "test"
pred.test <- predict(fit, newdata=test, type="class")
CM <- confusionMatrix(pred.test, test$classLab)
CM

#insample
# tic()
# fit_insample <- nn.rep(rep = 30, classLab ~ ., data = dat.scaled,
#               size = best_unit, linout = F, trace = FALSE, MaxNWts=100000 )
# toc()
# 
# results <- predict(fit_insample, newdata=test, type="class")
# conf <- confusionMatrix(results, test$classLab)
# conf

# pred.test1 <- predict(fit1, newdata=test, type="class")
# CM1 <- confusionMatrix(pred.test1, test$classLab)
# CM1
# 
# pred.test2 <- predict(fit2, newdata=test, type="class")
# CM2 <- confusionMatrix(pred.test2, test$classLab)
# CM2
# 
# pred.test3 <- predict(fit3, newdata=test, type="class")
# CM3 <- confusionMatrix(pred.test3, test$classLab)
# CM3
# 
# pred.test4 <- predict(fit4, newdata=test, type="class")
# CM4 <- confusionMatrix(pred.test4, test$classLab)
# CM4
# 
# pred.test5 <- predict(fit5, newdata=test, type="class")
# CM5 <- confusionMatrix(pred.test5, test$classLab)
# CM5
