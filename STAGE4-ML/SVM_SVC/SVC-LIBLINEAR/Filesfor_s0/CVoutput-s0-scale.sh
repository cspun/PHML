#!/bin/bash
#for checking
#for i in $(seq 1 19); do wc -l out-test-${i}.txt; done
#for i in $(seq 1 19); do wc -l out-train-${i}.txt; done
#for i in $(seq 1 19); do
#python checkdata.py out-train-${i}.txt
#python checkdata.py out-test-${i}.txt
#done
#set permission first
#chmod u+x ./libsvm-codes.sh before running ./libsvm-codes.sh on command line
#to FIND CV parameters
#1) Create pseudo Train Tseduo test and do a 18-fold (LOOCV) to find parameters
#for i in $(seq 1 19); do
#./train -C -s 0 -v 18 out-train-${i}.txt ;# not using this trained model for prediction yet
#./predict -b 1 out-test-${i}.txt out-train-${i}.txt.model output_${i};
#done
#RETRAIN model using the full DTR: results for -s 0
./svm-scale -l 0 -u 1 -s range.scale out-train.txt > out-train.scale;
./svm-scale -r range.scale out-test.txt > out-test.scale;
./train -s 0 -c 16 out-train.scale ;
./predict -b 1 out-test.scale out-train.scale.model output-scale.txt;




#output stored manually in output-combined.txt
#common errors:
#1)can't open model file out-train-13.model is because the model file is <train file full name>.model missed out the.txt earlier on ( take note of file names carefully!)
#COPIED FROM SVM-MANUAL-SCRIPT.SH
#./svm-scale -l 0 -u 1 -s range-${i} out-train-${i}.txt > out-train-${i}.scale;
#./svm-scale -r range-${i} out-test-${i}.txt > out-test-${i}.scale;
#./svm-train out-train-${i}.scale ;
#./svm-predict out-test-${i}.scale out-train-${i}.scale.model output_${i};
