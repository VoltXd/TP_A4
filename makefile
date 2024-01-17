CXX = gcc
CFLAGS = -Wall -fopenmp -O3 -save-temps
LDLIBS=-lm

OBJ= $(SRC:.c=.o)
BIN=exo1/exo1 exo2/exo2 exo3/exo3

fichier:
	$(CXX) $(CFLAGS) fichier.c -o fichier

clean: 
	rm $(BIN) *.o *.i *.s 