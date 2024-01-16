CXX = gcc
CFLAGS = -Wall -fopenmp -O3 -save-temps
LDLIBS=-lm

fichier:
	$(CXX) $(CFLAGS) fichier.c -o fichier