#/bin/bash

for i in {1..100}
do
    ./ShiTomasi  input_images/img_4.jpg 4 1024 | tee -a tmp
done

grep '^Convolution' tmp | tee -a result.csv
grep '^Eigen' tmp | tee -a result.csv
rm tmp

sed 's/[A-Za-z ]//g' result.csv | tee result.csv