#Last modified: 20Feb2018: reference from dissimilarity_rips_bottleck_RTform20.rmd
#LOAD PACKAGES
library("TDA")# for intervals
library("bio3d")# for pdb

#Read in the intervals produce in stage I:
#read in all "interval containing" csv files
setwd("~/Desktop/Rfiles-SEQ/stageII-similarity-computation")
fileNames <- Sys.glob("~/Desktop/Rfiles-SEQ/StageI-CompareIntervals/RDC-TDA-INTERVALS-RIPS20_ALPHA/RDC-TDA_INTERVALS-ALPHA/Alpha_*.csv")
#fileNames <- Sys.glob("InputFilesINTERVALS/RDC-TDA_INTERVALS-ALPHA/Alpha*.csv")
#create a list with intervals and save file names used for future indexing uses:
listNames <- lapply(fileNames,read.csv,header=T)
#write.csv(fileNames,"Bottleneck-dist/RDC-TDA-ALPHA-BOTTLENECK/RDC_TDA_Alpha_bottleneck_SMAT_filenames.csv")

#HELPER FUNCTION 1:
#INPUT:2 interval FOR COMPARISON: file_A,file_B
#OUTPUT: AVERAGE SIMILARITY FROM EACH DIM
#max_dim <- 2 #include components, loops and cavities
#max_scale <- 20(alr considered before intervals generated)
bottleneck_similarity <- function(file_A,file_B){
    BN_sim <- c(rep("NA",3))
    for (i in 0: 2){
        file_A <- as.matrix(file_A)
        file_B <- as.matrix(file_B)
        Diag1 <- file_A[file_A[,1]==i,,drop=F]
        Diag2 <- file_B[file_B[,1]==i,,drop=F]
        BN_sim[i+1] <- bottleneck(Diag1,Diag2,dimension=i)
    }
    
    output_sim <- as.numeric(BN_sim)
    return(mean(output_sim))
    #return(output_sim)
}

#FUNCTION 2: uses helper function 1
#INPUT:FILE LIST(>2) FOR COMPARISON[ ALL FILES STORED IN DYNAMIC.LS]
#OUTPUT: AVERAGE SIMILARITY FROM EACH DIM BETWEEN EACH FILE

bottleneck_sMAT <- function(file_list){
  n_files <- length(file_list)
  #read in the files sequentially
  #initialise the similarity matrix output:
  sMAT <- matrix(rep(NA,(n_files*n_files)),n_files,n_files)
  for (i in 2: n_files){
      for (j in 1: (i-1)){
        sMAT[i,j] <- bottleneck_similarity(file_list[[i]],file_list[[j]])# lower trianglular
      }
  }
    sMAT_lower <- sMAT #save a copy in case
    #Assign value to diagonals:
    diag(sMAT) <- rep(0,n_files)
    #replace upper triangular w lower triangular elements (since symmetric)
    ind <- upper.tri(sMAT)
    sMAT[ind] <- t(sMAT)[ind]
    return(sMAT)
}

#RUN FUNCTION 2:
library(tictoc)
tic()
ALL_sim <- bottleneck_sMAT(listNames)
#write.csv(fileNames,"~/Desktop/Rfiles-SEQ/stageII-similarity-computation/RDC-TDA-ALPHA/RDC-TDA-ALPHA-BOTTLENECK/RDC-TDA-ALPHA-BOTTLENECK_SMAT_filenames.csv")
write.csv(ALL_sim,"~/Desktop/Rfiles-SEQ/stageII-similarity-computation/RDC-TDA-ALPHA/RDC-TDA-ALPHA-BOTTLENECK/RDC-TDA-ALPHA-BOTTLENECK_SMAT.csv")
toc()
