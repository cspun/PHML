##Output evaluation:
#read in the output file
output_data=read.table("~/Desktop/Rfiles-SEQ-AB/stageIII-ML/RDC-TDA-RIPS20-40bins-ESTF-LIBLINEAR/Liblinear-s0-ESTF-RIPS/output.txt",header=T)
#The predicted class labels are stored in first column
class_pred=output_data[,1]
#create confusion matrix using output 
class_true=c(rep(1,30),rep(2,30),rep(3,30))
CM<-table(class_pred,class_true)
CM
#Calculate %accuracy for each class:
acc_class1=CM[1,1]/30
acc_class1#0.2333333
acc_class2=CM[2,2]/30
acc_class2# 0.7333333
acc_class3=CM[3,3]/30
acc_class3# 0.7333333
acc_overall=(CM[1,1]+CM[2,2]+CM[3,3])/90
acc_overall
