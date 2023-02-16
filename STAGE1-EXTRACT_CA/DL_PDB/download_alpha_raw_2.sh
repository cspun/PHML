#!/bin/bash

declare -i n=1
while read line
do
    location="http://scop.berkeley.edu/astral/pdbstyle/ver=2.05&id="$line"&output=txt"
    #a=$n
    name=/home/lees0159/DL_MBMB/alpha_raw_2/A_raw_$line.pdb
    wget $location -O $name -a logfile
    n=$n+1
done <alpha_list

