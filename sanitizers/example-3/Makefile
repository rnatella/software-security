#!/usr/bin/make

CC=gcc
CFLAGS=-O2 -g

titanic: titanic.c
	$(CC) $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	-rm titanic
