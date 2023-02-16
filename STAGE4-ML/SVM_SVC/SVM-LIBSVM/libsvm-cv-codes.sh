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
#./svm-scale -r range-${i} out-test-${i}.txt > out-test-${i}.scale;
./grid.py -log2c -14,14,1 -log2g -6,3,2 -svmtrain ./svm-train out-train.txt ;
#./grid.py -v 18 out-train-${i}.scale ;# not using this trained model for prediction yet
#./grid.py -log2c -1,2,1 -log2g 1,1,1 -t 0
#./easy.py out-train-${i}.txt{i}
#./predict -b 1 out-test-${i}.txt out-train-${i}.txt.model output_${i};
#done

