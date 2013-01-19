CC = gcc
CFLAGS = -g -w -Wall -O3 -Wno-deprecated -static
OBJ  = ./main.o ./crf.o ./crf_thread.o ./lbfgs.o ./fun.o
LINKOBJ  = ./main.o ./crf.o ./crf_thread.o ./lbfgs.o ./fun.o
BIN  = ./crf


LIBRARIES = -lm -lnsl -dl  -lstdc++ -lpthread

.PHONY: all all-before all-after clean clean-custom

all: ./crf


clean: clean-custom
		rm -f $(OBJ) $(BIN)

$(BIN): $(LINKOBJ)
		$(CC) $(CFLAGS) $(LINKOBJ) -o $(BIN) $(LIBRARIES)

./main.o: main.cpp crf.h fun.h
		$(CC) $(CFLAGS) -c ./main.cpp -o ./main.o

./crf_thread.o: crf_thread.cpp crf_thread.h
		$(CC) $(CFLAGS) -c ./crf_thread.cpp -o crf_thread.o

./crf.o: crf.cpp crf.h fun.h lbfgs.h thread.h crf_thread.h dat.h
		$(CC) $(CFLAGS) -c crf.cpp -o crf.o

./lbfgs.o: lbfgs.cpp lbfgs.h
		$(CC) $(CFLAGS) -c lbfgs.cpp -o lbfgs.o

./fun.o: fun.cpp fun.h
		$(CC) $(CFLAGS) -c fun.cpp -o fun.o
