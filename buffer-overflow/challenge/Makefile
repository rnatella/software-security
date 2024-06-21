PLATFORM := $(shell uname -m)

# On ARM computers, cross-compile to x86_64
ifeq ($(PLATFORM),aarch64)
        CC = x86_64-linux-gnu-gcc
endif

all: wisdom-alt wisdom-alt-32

wisdom-alt: wisdom-alt.c
	$(CC) -fno-stack-protector  -z execstack  -g  wisdom-alt.c  -o wisdom-alt

wisdom-alt-32: wisdom-alt.c
	$(CC) -fno-stack-protector  -z execstack  -g -m32  wisdom-alt.c  -o wisdom-alt-32

clean:
	rm -f wisdom-alt wisdom-alt-32
