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
./svm-scale -l 0 -u 1 -s range.scale out-train.txt > out-train.scale;
./svm-scale -r range.scale out-test.txt > out-test.scale;
./svm-train out-train.scale ;
./svm-predict out-test.scale out-train.scale.model output-scale.txt;
#output stored manually in output-combined.txt
#common errors:
#1)can't open model file out-train-13.model is because the model file is <train file full name>.model missed out the.txt earlier on ( take note of file names carefully!)

