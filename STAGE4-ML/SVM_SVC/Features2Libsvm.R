#Load Libraries
library(e1071)
library(SparseM)
#Load in input data ie the n*n sMAT
sMAT<-read.csv("~/Desktop/Rfiles-SEQ-AB/stageIII-ML/InputFilesLIB/RDC-TDA_RIPS-FEATURES/RDC_TDA_RIPS20_FEATURES.csv",header=F)
#include class labels first ( augment one column to the n*n smat)
n_class1=150#refers to A_B
n_class2=150#refers to A
n_class3=150# refers to B
labels=c(rep(1,n_class1),rep(2,n_class2),rep(3,n_class3))
dat=cbind((labels),sMAT)#add labels to first column
# Stratified sampling of Tr indice and Te indice
#20-80 split
set.seed(1)
tr_ind_AB<-sort(sample(1:150,120,replace=F))
tr_ind_A<-sort(sample(151:300,120,replace=F))
tr_ind_B<-sort(sample(301:450,120,replace = F))
tr_ind<-c(tr_ind_AB,tr_ind_A,tr_ind_B)#augment all the selected ind for Dtr
train.dat<-dat[tr_ind,]#gives a 360*12 mat
test.dat<-dat[-(tr_ind),]# gives a 90*12 mat

#function 1 to convert Dte from sMAT2lib format:
data2libsvmTR=function(mat,filename){
    # convert from data.frame to matrix format
    x.tr <- as.matrix(mat[,-1])
    # put the labels in a separate vector
    y.tr <- mat[,1]
    # convert to compressed sparse row format
    xs.tr <- as.matrix.csr(x.tr)
    # write the output libsvm format file 
    write.matrix.csr(xs.tr, y=y.tr, file=filename) 
    
}

#function2 to convert Dte from sMAT2lib format:
data2libsvmTE=function(mat){
  # convert from data.frame to matrix format
  x.te <- as.matrix(mat[,-1])
  # put the labels in a separate vector
  y.te <- mat[,1]
  # convert to compressed sparse row format
  xs.te <- as.matrix.csr(x.te)
  # write the output libsvm format file 
  write.matrix.csr(xs.te, y=y.te, file="~/Desktop/Rfiles-SEQ-AB/stageIII-ML/InputFilesLIB/RDC-TDA_RIPS-FEATURES/out-test.txt") 
  
}

#create sparse format data
out.train.filename="~/Desktop/Rfiles-SEQ-AB/stageIII-ML/InputFilesLIB/RDC-TDA_RIPS-FEATURES/out-train.txt"
data2libsvmTR(train.dat,out.train.filename)
data2libsvmTE(test.dat)# returns 1,2,.. diagonals gone since 0: sparse format will make it gone pls dont be shocked LOL

