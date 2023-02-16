#neural net with ESTF binned features
#Load data
#dat <- read.csv("./RDC_TDA_RIPS20_FEATURES.csv", header = F)
dat <- read.csv("./RDC_TDA_ALPHA_FEATURES.csv", header = F)
#include class labels first ( augment one column to the n*n smat)
n_class1 <- 300#refers to A_B
n_class2 <- 300#refers to A
n_class3 <- 300# refers to B
labels <- c(rep(1,n_class1),rep(2,n_class2),rep(3,n_class3))
dat <- cbind((labels),dat)#add labels to first column
names(dat)[1] <- "classLab"

#Data split
#20-80 split
set.seed(1)
tr_ind_AB <- sort(sample(1:300,240,replace=F))
tr_ind_A <- sort(sample(301:600,240,replace=F))
tr_ind_B <- sort(sample(601:900,240,replace = F))
tr_ind <- c(tr_ind_AB,tr_ind_A,tr_ind_B)#augment all the selected ind for Dtr
#traindata <- dat[tr_ind,]#gives a 360*nfeatures mat
#testdata <- dat[-(tr_ind),]# gives a 90*nfeatures mat

#standardisation
# compute the mean and sd of the TRAINING sets input
(dat.mean <- apply(dat[tr_ind, -1], 2, mean))
(dat.sd <- apply(dat[tr_ind, -1], 2, sd))
# standardization (x - center) / scale
dat.scaled <- data.frame(scale(x = dat[-1],
                                  center = dat.mean,
                                  scale = dat.sd),
                            classLab = dat[1])
dat.scaled$classLab <-as.factor((dat.scaled$classLab))
train.dat <- dat.scaled[tr_ind, ]
test.dat <- dat.scaled[-tr_ind, ]

# check the mean and sd
#apply(train.dat , 2, mean)
#apply(train.dat , 2, sd)
