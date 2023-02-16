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
path <- "."
pdbFiles <- list.files(path=path, pattern="*_CA.pdb", full.names = FALSE)#extract all files with .pdb extensions
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

#initialise parameters
max_scale <- 20 #20\angstrom max filtration value
max_dimension <- 2 #refers to cavities/Betti 2

files[1]
#Note: same indexing between point_cloud.dynamic.ls[[i]] and pdb.dynamic.ls[[i]]
#Example: Testing one by one:
rips_int1_test <- ripsDiag(X=point_cloud.dynamic.ls[[2]], maxscale=max_scale, 
                           maxdimension=max_dimension, dist="euclidean", 
                           library=c("GUDHI","Dionysus"), printProgress = T)
Diag <- rips_int1_test$diagram
plot(rips_int1_test$diagram,barcode = T,dimension=0)

#for extended report
rips_A_test <- ripsDiag(X=point_cloud.dynamic.ls[[1]], maxscale=max_scale, 
                           maxdimension=max_dimension, dist="euclidean", 
                           library=c("GUDHI","Dionysus"), printProgress = T)
plot(rips_A_test$diagram,barcode = T)
rips_AB_test <- ripsDiag(X=point_cloud.dynamic.ls[[1]], maxscale=max_scale, 
                           maxdimension=max_dimension, dist="euclidean", 
                           library=c("GUDHI","Dionysus"), printProgress = T)
plot(rips_AB_test$diagram,barcode = T)
rips_B_test <- ripsDiag(X=point_cloud.dynamic.ls[[1]], maxscale=max_scale, 
                           maxdimension=max_dimension, dist="euclidean", 
                           library=c("GUDHI","Dionysus"), printProgress = T)
plot(rips_B_test$diagram,barcode = T)
#Generating intervals using RIPS
#Step 1:Start parallel programming: load necessary packages
library(tictoc) # to time each step
tic()
library(doParallel)
nbcores <- 4 # number of cores of your laptop (minus 1!)
cl <- makeCluster(nbcores)
registerDoParallel(cl)

#Step 2: Generate RIPS intervals stored in list "Rips.dynamic.ls"
Rips.dynamic.ls <- list()
Rips.dynamic.ls <- foreach(i=1:length(pdbFiles), .packages ="TDA") %dopar%
(
ripsDiag(X=point_cloud.dynamic.ls[[i]], maxscale=max_scale,
         maxdimension=max_dimension, dist="euclidean",library=c("GUDHI","Dionysus"),
         printProgress = F)
)

#Step 3: Output each set of intervals for each protein into separate csv files
#Note: same indexing between Rips.dynamic.ls[[i]] and point_cloud.dynamic.ls[[i]]
for (i in 1: length(Rips.dynamic.ls)){
  tmp <- Rips.dynamic.ls[[i]]
  tmp <- tmp[["diagram"]] #this returns the required 3 column outut of dimension, birth , death
  write.csv(tmp, file=paste("Rips",max_scale,"_", filename[i], ".csv", sep = ""), row.names = F)
}
toc()
stopCluster(cl)

#Step 4: Barcode plots for each interval in Rips.dynamic.ls[[i]]
for (i in 1:length(point_cloud.dynamic.ls)){
  mypath <- file.path("~/R",paste("Rips20_TDA_barcode_", filename[i], ".jpg", sep = "")) #where to store the plots
  jpeg(file=mypath)
  mytitle = paste("PDB file:", filename[i])
  plot(Rips.dynamic.ls[[i]]$diagram, main=mytitle,barcode = T)
  dev.off()
}