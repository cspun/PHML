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
./svm-scale -l 0 -u 1 out-train.txt > out-train.scale;
./train -C -s 0 -v 5 out-train.scale ;# not using this trained model for prediction yet
#./predict -b 1 out-test-${i}.txt out-train-${i}.txt.model output_${i};

