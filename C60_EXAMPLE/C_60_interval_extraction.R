library("TDA") # for interval generation
dat <- read.table("../C60_EXAMPLE/C60.xyz",skip=2)
dat.xyz <- dat[,c(2:4)]

#RIPS
max_scale <- 12 #20\angstrom max filtration value
max_dimension <- 2 #refers to cavities/Betti 2
rips_int1_test <- ripsDiag(X=dat.xyz, maxscale=max_scale, 
                           maxdimension=max_dimension, dist="euclidean", 
                           library=c("GUDHI","Dionysus"), printProgress = T)
#sample barcode plot
plot(rips_int1_test$diagram,barcode = T)

#ALPHA
alpha_int1_test <- alphaComplexDiag(X =dat.xyz, 
                                    library = c("GUDHI", "Dionysus"),
                                    printProgress = TRUE) #needs to be scaled: take sqrt*2
plot(alpha_int1_test$diagram, barcode=T)
