# ESTF-V3-features-extraction to PCA biplot
sMAT <- read.csv("~/Desktop/Rfiles-SEQ-AB/stageIII-ML/InputFilesLIB/Features/RDC-TDA-ALPHA-ESTF-features/RDC-TDA-ALPHA-ESTF-features500-50.csv", header=T)
sMAT <- sMAT[,-1]
#include class labels first ( augment one column to the n*n smat)
n_class1 <- 150#refers to A_B
n_class2 <- 150#refers to A
n_class3 <- 150# refers to B
labels <- c(rep(1, n_class1), rep(2, n_class2), rep(3, n_class3))
dat <- cbind((labels), sMAT)#add labels to first column
#PCA using original DATA####
pca<-prcomp(dat)
#elbow/scree plot
plot(pca,type="l")
#based on elbow plot, first 3 PCs can explain variance quite well
#summary(pca)
#plot pca with first 2 PCS
plot(predict(pca)[,1:2],pch=labels,col=labels)
title("PCA of Original Data")
legend("bottomleft",pch=1:3,col=1:3,legend=c("AB","A","B"))

#plot pca1 with first 2 PCS
#scale only works with non zero variance data ( must remove constant features first!)
dat1 <- removeConstantFeatures(dat)
pca1<-prcomp(dat1,scale=TRUE)
#elow/Scree plot
plot(pca1,type='l')
plot(predict(pca1)[,1:2],pch=labels,col=labels)
title("PCA of Scaled and non constant Data")
legend("bottomleft",pch=1:3,col=1:3,legend=c("AB","A","B"))
