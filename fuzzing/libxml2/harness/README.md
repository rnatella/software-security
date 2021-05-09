To install AFL (the AFL++ fork) on Ubuntu:
```
$ sudo apt install afl++ afl++clan
```

To build libxml2 with AFL-clang (binary code instrumentation for coverage-driven fuzzing):
```
$ cd libxml2-2.9.2

$ CC=afl-clang-fast ./configure --with-python=no --disable-shared

$ AFL_USE_ASAN=1 make -j 4 libxml2.la

$ cd ..
```


To build the target executable (statically linked to libxml2):
```
$ AFL_USE_ASAN=1 afl-clang-fast harness.c ./libxml2-2.9.2/.libs/libxml2.a -o harness  -I./libxml2-2.9.2/include -lm -lz
```


To run AFL:
```
$ sudo bash -c 'echo core >/proc/sys/kernel/core_pattern'

$ mkdir output_afl

$ afl-fuzz -i <PATH>/go-fuzz-corpus/xml/corpus/ -o output_afl/ -m none  -- ./harness @@
```
