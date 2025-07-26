.PHONY: clean all test

CC ?= gcc
CCFLAGS ?= -g -Wall -Wextra -std=c99

all: findp

findp: findp.c mystring.o
	$(CC) $(CCFLAGS) -o findp findp.c mystring.o

test:
	@/bin/bash tests/test-mystring.sh
	@echo ""
	@/bin/bash tests/test-findp.sh

mystring.o: mystring.c
	$(CC) $(CCFLAGS) -o mystring.o -c mystring.c

clean:
	rm -f findp mystring.o
	@rm -rf tests/test-mystring *.dSYM tests/*.dSYM
