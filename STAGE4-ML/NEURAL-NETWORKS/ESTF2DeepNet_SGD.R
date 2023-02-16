library(keras)
library(tictoc)
#read in data 
source("./ESTF_dataload.R")
set.seed(1)
index <- sample(360,360)
train.dat <- train.dat[index,] #shuffle the training samples
trainlabel <- train.dat[,1]
testlabel <- test.dat[,1]
traindata <- train.dat[,-1]
testdata <- test.dat[,-1]
#remove variables with nzr
nzv <- nearZeroVar(traindata)
traindata <- traindata[,-nzv]
testdata <- testdata[,-nzv]

#convert data into matrix form to be taken as inputs to keras
traindata <- as.matrix(traindata)
testdata <- as.matrix(testdata)
traindata <- normalize(traindata)
testdata <- normalize(testdata)
trainlabel <- to_categorical(trainlabel)
testlabel <- to_categorical(testlabel)

use_session_with_seed(1)
model <- keras_model_sequential() 
tic()
# model %>%
# 
#   layer_dense(units = 256, activation = 'relu', input_shape = c(ncol(traindata))) %>%
#   layer_dropout(rate=0.2) %>%
#   layer_dense(units = 1024, activation = 'relu') %>%
#   layer_dropout(rate=0.3) %>%
#   layer_dense(units = 1024, activation = 'relu') %>%
#   layer_dropout(rate=0.3) %>%
#   layer_dense(units = 3, activation = 'softmax')

#version 2
#n_units=?
model %>%
  layer_dense(units= n_units, activation = 'relu', input_shape = c(ncol(traindata))) %>%
  layer_dropout(rate=0.3) %>%
  layer_dense(units = n_units, activation = 'relu') %>%
  layer_dropout(rate=0.3) %>%
  layer_dense(units = 2*n_units, activation = 'relu') %>%
  layer_dropout(rate=0.3) %>%
  layer_dense(units = 3, activation = 'softmax')
sgd <- optimizer_sgd(lr = 0.4, decay=0.01)#,decay=0.01

model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = sgd,
  metrics = 'accuracy'
)
history<-model %>% fit(
  traindata, 
  trainlabel, 
  epochs = 600, 
  batch_size = 200, 
  validation_split = 0.2
)
toc()

classes <- model %>% predict_classes(testdata)
verifytestlabel <- test.dat[,1]
CM <- confusionMatrix(classes,verifytestlabel)
CM
probs <- model %>% predict_proba(testdata)
cbind(probs, classes, verifytestlabel)
summary(model)
summary(model)
ncol(traindata)
