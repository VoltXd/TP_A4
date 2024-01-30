#!/bin/bash
print "VERSION NON-OPTI"
./Modele_exo4/ShiTomasi ./Modele_exo4/input_images/img_1.jpg 10 1024
print "VERSION OMP"
./Opti_exo4/ShiTomasi ./Opti_exo4/input_images/img_1.jpg 10 1024
