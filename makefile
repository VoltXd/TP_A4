CXX = gcc
CFLAGS = -Wall -fopenmp -O3
LDLIBS=-lm

EX1=exo1/exo1
EX2=exo2/exo2
EX3=exo3/exo3

BIN=$(EX1) $(EX2) $(EX3)

all: ex1 ex2 ex3

ex1: 
	$(CXX) $(CFLAGS) $(EX1).c -o $(EX1)

ex2: 
	$(CXX) $(CFLAGS) $(EX2).c -o $(EX2) $(LDLIBS)

ex3: 
	$(CXX) $(CFLAGS) $(EX3).c -o $(EX3)

clean: 
	rm -f $(BIN) *.o *.i *.s 