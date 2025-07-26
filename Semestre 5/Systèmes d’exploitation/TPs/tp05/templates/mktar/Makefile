.PHONY: clean all test

CC ?= gcc
CCFLAGS ?= -g -Wall -Wextra -std=c99

all: mktar

mktar: mktar.c mystring.o tarutils.o
	$(CC) $(CCFLAGS) -o mktar mktar.c mystring.o tarutils.o

mystring.o: mystring.c
	$(CC) $(CCFLAGS) -o mystring.o -c mystring.c
tarutils.o: tarutils.c
	$(CC) $(CCFLAGS) -o tarutils.o -c tarutils.c

clean:
	rm -f mktar mystring.o tarutils.o




