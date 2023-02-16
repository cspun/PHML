#Load Libraries:####
library(magrittr)
library(wordVectors)
library(ggplot2)
library(gplots)
library(doParallel)
library(tictoc)

#read in interval Files:####
#read in all "interval containing" csv files
#fileNames=Sys.glob("~/Desktop/Rfiles-SEQ-AB/stageI-IntervalExtract/RDC-TDA-INTERVALS-RIPS20/Rips20*.csv")
fileNames <- Sys.glob("~/Desktop/Rfiles-SEQ-AB/stageI-IntervalExtract/RDC-TDA-INTERVALS-ALPHA/Alpha_scaled*.csv")
#create a list with intervals and save file names used for future indexing uses:
listNames <- lapply(fileNames, read.csv, header=T)
#write.csv(fileNames,"~/Desktop/Rfiles-SEQ-AB/stageII-SimilarityComputation/RDC-TDA-ESTF/RDC-TDA-Alpha_scaled-ESTF-filenames_TEST.csv")
#Determine the L- only for alpha complex####
#interval_stats <- read.csv("~/Desktop/Rfiles-SEQ-AB/stageI-IntervalExtract/codes-interval-stats-compare/interval-extraction_ALPHA_TDA-output.csv",header=T)
#max(interval_stats[,7:10])#38.62641: set 50 should be safe
#Filter out the longest B0 bar first: extends to infinity for every bar
#fix the i- the short interval we counting from 
#input: the intervals of dim0/1/2
#Helper 1: for fixed i and dimj=0/1/2####
ESTF_feature_extract_bin_dimj <- function(bin_i,interval,nres,L){
  #interval=interval[is.finite(rowSums(interval)),]
  #initialise parameters used: this is the mini intervals used to extract out the nres features
  int_div=L/nres
  # i=c(1:nres)
  # upp=i*int_div#nres vec
  # low=(i-1)*int_div#nres vec
  upp=bin_i*int_div#nres vec
  low=(bin_i-1)*int_div#nres vec
  #extract V_b,V_d,V_p is the the corr 1*nres vector 
  v_b=sum(interval[,2]<=upp & interval[,2]>=low)
  v_d=sum(interval[,3]<=upp & interval[,3]>=low)
  v_p=sum(interval[,2]<=low & interval[,3]>=upp)
  v_i=c(v_b,v_d,v_p)#1*3 vec
  # V_i=rbind(v_b,v_d,v_p)
  return(v_i)#a 3*nres vector
}
#Helper 2: for all i=1:nres and dimj=0/1/2###
#returns nres by 3 vector of features for dimj
ESTF_feature_extract_dimj <- function(interval,nres,L){
  outlist=lapply(1:nres,ESTF_feature_extract_bin_dimj,interval,nres,L)# returns a nres dimensional list
  outmat=matrix(unlist(outlist),nrow=1,byrow =T)
  return(outmat)
}
#repeat the function for all 3 dimension j=0,1,2
#Helper 3: for all i=1:nres and all dimj=0,1,2###
ESTF_feature_extract <- function(dimension,interval,nres,L){
  tmp=matrix(NA,nrow=1,ncol=0)
  mat=matrix(NA,nrow=1,ncol=0)
  for(i in 1:length(dimension)){
    tmp=ESTF_feature_extract_dimj(interval[interval[,1]==dimension[i],],nres,L)#returns a 3by nres matrix
    mat=cbind(mat,tmp)
    }
  return(mat)#should return a 1 by length(dimension)*3 by nres long vector
}
#ESTF_feature_extract(c(0,1,2),listNames[[1]],60,30)
ESTF_feature_extract_mat <- function(dimension, interval_list,nres,L){
  ESTF_feature_mat=matrix(NA,nrow=length(interval_list),ncol=0)
  indexvec=1:length(interval_list)
  ESTF_feature_mat=foreach(i=indexvec,.combine='rbind')%do%
    ESTF_feature_extract(dimension,interval_list[[i]],nres,L)
  return(ESTF_feature_mat)
}
tic()
# x <-ESTF_feature_extract_mat(c(0,1,2), listNames, 40, 20)#40*3*3 (for rips20)
# x <- ESTF_feature_extract_mat(c(0,1,2),listNames, 50*4, 50)
# x <-ESTF_feature_extract_mat(c(0,1,2), listNames, 200, 20)
x <-ESTF_feature_extract_mat(c(0,1,2),listNames, 100, 50)
toc()
dim(x) # should always have 450 rows
#write.csv(x, "RDC-TDA-RIPS20-ESTF-features40-20.csv")
#write.csv(x, "RDC-TDA-ALPHA-ESTF-features200-50.csv")
#write.csv(x, "RDC-TDA-RIPS20-ESTF-features200-20.csv")
#write.csv(x, "RDC-TDA-ALPHA-ESTF-features500-50.csv")#48.08s
#write.csv(x, "RDC-TDA-RIPS20-ESTF-features80-20.csv") 
write.csv(x, "RDC-TDA-ALPHA-ESTF-features100-50.csv") 
# ESTF_feature_compare<-function(dimension,interval1,interval2,nres,L){
#   tmp1_mat=ESTF_feature_extract(dimension,interval1,nres,L) 
#   tmp2_mat=ESTF_feature_extract(dimension,interval2,nres,L) 
#   cos_sim=cosineSimilarity(tmp1_mat,tmp2_mat)%>% mean(.)
#   return(cos_sim)
# }
# tmp1=listNames[[1]]
# tmp5=listNames[[5]]
# tmp6=listNames[[6]]
# tmp1_mat=ESTF_feature_extract(c(0,1,2),tmp1,60,30) 
# tmp5_mat=ESTF_feature_extract(c(0,1,2),tmp5,60,30)
# tmp6_mat=ESTF_feature_extract(c(0,1,2),tmp6,60,30) 
# cosineSimilarity(tmp1_mat,tmp5_mat)
# cosineSimilarity(tmp1_mat,tmp6_mat)

# ESTF_cosMAT=function(filenames,dimension,nres,L){
#   n_files=length(filenames)
#   #read in the files sequentially
#   #initialise the similarity matrix output:
#   sMAT=matrix(rep(NA,(n_files*n_files)),n_files,n_files)
#   for (i in 2: n_files){
#     for (j in 1:(i-1)){
#       sMAT[i,j]=ESTF_feature_compare(dimension,filenames[[i]],filenames[[j]],nres,L)# lower trianglular
#     }
#   }
#   sMAT_lower=sMAT #save a copy in case
#   #Assign value to diagonals:
#   diag(sMAT)=rep(1,n_files)
#   #replace upper triangular w lower triangular elements (since symmetric)
#   ind<-upper.tri(sMAT)
#   sMAT[ind]<-t(sMAT)[ind]
#   return(sMAT)
# }
# #creating ESTF_cosMAT####
# tmp_sMAT=ESTF_cosMAT(listNames,c(0,1,2),150,30)
#Visualisation####
# tmp_sMAT %>% heatmap.2(scale="none", trace = "none", col="greenred",
#                        colsep = c(5),rowsep = c(5),Rowv = F,Colv = F)
# tmp_sMAT %>% heatmap.2(scale="none", trace = "none", col="greenred",
#                        colsep = c(5),rowsep = c(5))
