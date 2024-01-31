CC=gcc
CCFLAGS=-Wall -std=c99 -fopenmp
LDFLAGS=-lm -fopenmp
SOURCES=$(wildcard *.c)
OBJECTS=$(SOURCES:.c=.o)
TARGET=ShiTomasi

all: debug

debug: CCFLAGS += -DDEBUG -g
debug: $(TARGET)

release: CCFLAGS += -O2
release: $(TARGET)

benchmode: CCFLAGS += -O2 -g
benchmode: $(TARGET)

$(TARGET): $(OBJECTS) $(CXXOBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c %.h
	$(CC) $(CCFLAGS) -c $<

%.o: %.c
	$(CC) $(CCFLAGS) -c $<

clean:
	rm -f *.pgm *.o $(TARGET)