#Install necessary packages:
# install.packages("doParallel")
# install.packages("TDA")
# install.packages("bio3d")

#LOAD PACKAGES
library("bio3d") # for pdb reading
library("TDA") # for interval generation

#For more information on each package: 
#e.g. type ?ripsDiag to find out on usage and arguments
#CREATE DYNAMIC LIST OF FILES (*_CA.pdb) within folder "path"
path <- "./InputFilesPDB_CA2"
pdbFiles <- list.files(path=path, pattern="*CA.pdb", full.names = FALSE)#extract all files with .pdb extensions
filename <- gsub(".pdb","",pdbFiles)
# write.csv(filename,"CA_ALPHA_pdbfile_Names.csv",col.names=F,row.names =F)
files <- file.path(path, c(pdbFiles))
pdb.dynamic.ls <- list()
pdb.dynamic.ls <- lapply(files,read.pdb)
#Note: same indexing between pdb.dynamic.ls[[i]] and files/pdbFiles list

#Extract XYZ coordinate only
point_cloud.dynamic.ls<-list()
for (i in 1:length(files)){
  point_cloud.dynamic.ls[[i]]=pdb.dynamic.ls[[i]]$atom[, c("x","y","z")]
}

#Example: Testing one by one:
alpha_int1_test <- alphaComplexDiag(X = point_cloud.dynamic.ls[[1]], 
                                    library = c("GUDHI", "Dionysus"),
                                    printProgress = TRUE) #needs to be scaled: take sqrt*2
plot(alpha_int1_test$diagram, barcode=T)
alpha_int1_test_diag <- alpha_int1_test[["diagram"]]
alpha_int1_test_scaled <- cbind(alpha_int1_test_diag[,1], sqrt(alpha_int1_test_diag[,c(2,3),drop=F])*2)

#Generating intervals
#M1: For loop
Alpha.dynamic.ls=list()
for (i in 1:length(pdbFiles)){
  Alpha.temp <- alphaComplexDiag(X = point_cloud.dynamic.ls[[i]], library = c("GUDHI", "Dionysus"), printProgress = TRUE)
  Alpha.dynamic.ls[[i]] <- Alpha.temp
  interval.tmp <- Alpha.temp[["diagram"]]#not stored, scaled into alpha.scaled using RIPS
  #rescale the filtration distance first to that of rips: take square root *2
  alpha.scaled <- cbind(interval.tmp[,1,drop=F],sqrt(interval.tmp[,c(2,3),drop=F])*2)#not stored
  write.csv(alpha.scaled,file=paste("Alpha_", filename[i], ".csv", sep = ""),row.names = F)
}  

#M2: PARFOR loop
#Step 1:Start parallel programming: load necessary packages
library(doParallel)
nbcores <- 4 # number of cores of your laptop (minus 1!)
cl <- makeCluster(nbcores)
registerDoParallel(cl)
library(tictoc)
tic()
Alpha.dynamic.ls=list()
Alpha.dynamic.ls<-foreach(i=1:length(pdbFiles),.packages="TDA")%dopar%
{
  Alpha.temp <- alphaComplexDiag(X = point_cloud.dynamic.ls[[i]], library = c("GUDHI", "Dionysus"),printProgress = TRUE)
  Alpha.dynamic.ls[[i]] <- Alpha.temp
  interval.tmp <- Alpha.temp[["diagram"]]#not stored, scaled into alpha.scaled using RIPS
  #rescale the filtration distance first to that of rips: take square root *2
  alpha.scaled <- cbind(interval.tmp[,1,drop=F],sqrt(interval.tmp[,c(2,3),drop=F])*2) #not stored
  write.csv(alpha.scaled,file=paste("Alpha_scaled", filename[i], ".csv", sep = ""),row.names = F)
}
  stopCluster(cl)
toc()

#Generating barcode plots for intervals using alpha( diff scale for filtration)
for (i in 1:length(point_cloud.dynamic.ls)){
  mypath <-file.path("~/R",paste("Alpha_TDA_barcode_", filename[i], ".jpg", sep = ""))
  jpeg(file=mypath)
  mytitle = paste("PDB file:", filename[i])
  plot(Alpha.dynamic.ls[[i]]$diagram, main=mytitle,barcode = T)
  dev.off()
}