#!/usr/bin/make

CC=gcc
CFLAGS=-O0 -g -lm

titanic: titanic.c
	$(CC) $< $(CFLAGS) -o $@

.PHONY: clean
clean:
	-rm titanic
