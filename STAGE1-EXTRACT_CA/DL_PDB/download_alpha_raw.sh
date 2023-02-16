#!/bin/bash

declare -i n=1
while read line
do
    location="http://scop.berkeley.edu/astral/pdbstyle/ver=2.05&id="$line"&output=txt"
    a=$n #acts as a counter ( can change $a to $line to number the pdb files downloaded also)
    name=/home/lees0159/DL_MBMB/alpha_raw/A_raw_$a.pdb #location of where the files should be saved
    wget $location -O $name -a logfile
    n=$n+1
done <alpha_list

