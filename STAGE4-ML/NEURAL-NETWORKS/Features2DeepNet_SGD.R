library(keras)
library(tictoc)
library(caret)
#read in data 
source("./Features_dataload.R")
set.seed(1)
index <- sample(720,720) 

train.dat <- train.dat[index,] #shuffle the training samples
trainlabel <- train.dat[,1]
testlabel <- test.dat[,1]
traindata <- train.dat[,-1]
testdata <- test.dat[,-1]

#convert data into matrix form to be taken as inputs to keras
traindata <- as.matrix(traindata)
testdata <- as.matrix(testdata)
traindata <- normalize(traindata)
testdata <- normalize(testdata)
trainlabel <- to_categorical(trainlabel)
testlabel <- to_categorical(testlabel)

n_units <- 2^5#best when tried with 32,64,128
use_session_with_seed(1)
model <- keras_model_sequential() 
tic()
model %>%
  layer_dense(units= n_units, activation = 'relu', input_shape = c(ncol(traindata))) %>%
  layer_dropout(rate=0.3) %>%
  layer_dense(units = n_units, activation = 'relu') %>%
  layer_dropout(rate=0.3) %>%
  layer_dense(units = 2*n_units,activation = 'relu') %>%
  layer_dropout(rate=0.3) %>%
  layer_dense(units = 3,activation = 'softmax')# kernel_regularizer=regularizer_l2(0.001),

summary(model)
sgd <- optimizer_sgd(lr = 0.4)   #,0.4, decay=0.01
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = sgd,
  metrics = 'accuracy'
)
history <- model %>% fit(
  traindata, 
  trainlabel, 
  epochs = 900, #450
  batch_size = 200, 
  validation_split = 0.2
)
toc()

classes <- model %>% predict_classes(testdata)
verifytestlabel <- test.dat[,1]
CM <- confusionMatrix(classes,verifytestlabel)
CM
#check for overfitting or underfitting:
insampleclasses <- model %>% predict_classes(traindata)
verifytrainlabel <- train.dat[,1]
confusionMatrix(insampleclasses,verifytrainlabel)
summary(model)
ncol(traindata)

