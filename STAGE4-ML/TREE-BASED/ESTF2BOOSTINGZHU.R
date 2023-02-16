#install.packages("fastAdaboost")
#install.packages("adabag")
#library(fastAdaboost) #for Adaboost
library(caret) #for CM
library(tictoc)
library(adabag)
library(doParallel)
library(tictoc)
registerDoParallel()  
cl <- 4  
registerDoParallel(cl)  
#Load data
#source("./ESTF_dataload.R")
#dat <- read.csv("../RDC_TDA_RIPS20_FEATURES.csv",header=F)
dat <- read.csv("../RDC_TDA_ALPHA_FEATURES.csv",header=F)
## Adaboost
#training
m_final <- 100
max_depth <- 1

tic()
set.seed(1)
data.boostingZhuTrue <- boosting(classLab~., data=train.dat,
                                    boos=TRUE, mfinal=m_final, coeflearn = "Zhu",
                                    control=rpart.control(maxdepth=max_depth,minsplit = 0, cp=-1))
toc()
data.boosting <- data.boostingZhuTrue
data.predboost <-predict.boosting(data.boosting, newdata = test.dat)
# data.predboost$confusion
# data.predboost$error
sort(data.boosting$imp,decreasing = T)
CM <- confusionMatrix(data.predboost$class,test.dat$classLab)
CM
#importanceplot(data.boosting)

errorevol.train <- errorevol(data.boosting, train.dat)
errorevol.test <- errorevol(data.boosting, test.dat)
plot(errorevol.test[[1]], type = "l", ylim = c(0, 0.5),
         main = "Adaboost error versus number of trees", xlab = "Iterations",
         ylab = "Error", col = "red", lwd = 2)
lines(errorevol.train[[1]], cex = 0.5, col = "blue", lty = 1, lwd = 2)
  legend("topright", c("test", "train"), col = c("red", "blue"), lty = 1,
          lwd = 2)
abline(h = min(errorevol.test[[1]]), col = "red", lty = 2, lwd = 2)
abline(h = min(errorevol.train[[1]]), col = "blue", lty = 2, lwd = 2)

#pruning:
(newmfinal <- min(which(errorevol.test[[1]]==min(errorevol.test[[1]]))))
data.prune <- predict.boosting(data.boosting, newdata = test.dat,
                                newmfinal = newmfinal)
data.prune$confusion
CM_new <- confusionMatrix(data.prune$class, test.dat$classLab)
CM_new

sort(data.boosting$importance, decreasing = TRUE)
