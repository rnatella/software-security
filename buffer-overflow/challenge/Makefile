all: wisdom-alt wisdom-alt-32

wisdom-alt: wisdom-alt.c
	gcc -fno-stack-protector  -z execstack  -g  wisdom-alt.c  -o wisdom-alt

wisdom-alt-32: wisdom-alt.c
	gcc -fno-stack-protector  -z execstack  -g -m32  wisdom-alt.c  -o wisdom-alt-32

clean:
	rm -f wisdom-alt wisdom-alt-32
