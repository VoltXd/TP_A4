#/bin/bash

rm -f result_fin.csv

echo "winsize;numfeat;img;numthreads;time_conv;time_eigen" | tee -a result_fin.csv

for ws in 3 5 7 9
do
    for feat in 64 1024 4096
    do
        for img in "000009.png" "img_1.jpg" "img_2.jpg" "img_3.jpg" "img_4.jpg" "img_5.jpg"
        do
            for thread in {1..4}
            do
                echo "$ws;$feat;$img;$thread;" | tee -a result_fin.csv

                OMP_NUM_THREADS=$thread
                export OMP_NUM_THREADS

                rm -f tmp
                for moy in {1..10}
                do
                    ./ShiTomasi  input_images/$img $ws $feat | tee -a tmp
                done
                grep '^Convolution' tmp | sed 's/[A-Za-z ]//g' | tee -a result_fin.csv
                grep '^Eigen' tmp | sed 's/[A-Za-z ]//g' | tee -a result_fin.csv
            done
        done
    done
done