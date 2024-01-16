#!/bin/bash
for length in 1000 100000 10000000 100000000
do
    for num_threads in {2..16}
    do
        ./exo2 $length $num_threads | tee -a result.csv
    done
done