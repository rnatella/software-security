PLATFORM := $(shell uname -m)

# On ARM computers, cross-compile to x86_64
ifeq ($(PLATFORM),aarch64)
        CC = x86_64-linux-gnu-gcc
endif

vuln_server: vuln_server.c
        $(CC) -fno-stack-protector  -z execstack  -g  vuln_server.c  -o vuln_server

clean:
	rm -f vuln_server
