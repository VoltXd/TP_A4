CXX = gcc
CFLAGS = -Wall -fopenmp -O3
LDLIBS=-lm

OBJ= $(SRC:.c=.o)
BIN=exo1/exo1 exo2/exo2 exo3/exo3

fichier:
	$(CXX) $(CFLAGS) fichier.c -o fichier

clean: 
	rm -rf *.o *.i *.s 