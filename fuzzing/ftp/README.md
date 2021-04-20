Clone, patch, and install boofuzz from GitHub:

```
$ git submodule update --init --recursive

$ patch -d boofuzz -p1 < boofuzz-isalive.patch

$ cd boofuzz
$ pip3 install .
$ cd ..
```


Patch and build the (vulnerable) FTP server:

```
$ tar zxf hpaftpd.tgz

$ patch -d hpaftpd-1.05/  -p1 < hpaftpd-vulnerable.patch

$ cd hpaftpd-1.05
$ make CFLAGS="-g"
$ cd ..
```


To test that the FTP server actually works, run this command:
```
$ ./hpaftpd-1.05/hpaftpd -p2121  -l -unobody
```

On another shell, try to connect to the FTP server:
```
$ ftp localhost 2121
Connected to localhost.
220 HighPerfomanceAnonymousFTPServer
Name (localhost:so): anonymous
331 Password required for anonymous
Password:

230 User anonymous logged in
Remote system type is UNIX.

ftp> ls
200 Command ok.
150 Open data connection
-rw-------    1 root root 1964400640 Sep 27 18:53 swapfile
drwx------    2 root root     16384 Sep 27 18:53 lost+found
drwxr-xr-x    2 root root      4096 Jul 31 18:27 mnt
226 Transfer complete

ftp> pwd
257 "/" is current work directory.

ftp> quit
221 Goodbye.
```



To perform fuzzing on the FTP server, first run the process monitor.
On crashes of the FTP server, it will store the core dump, and restart the FTP server for the next test.

```
$ ulimit -c unlimited
$ mkdir coredumps
$ python3 boofuzz/process_monitor_unix.py -d coredumps

[04:11.23] Process Monitor PED-RPC server initialized:
[04:11.23] 	 listening on:  0.0.0.0:26002
[04:11.23] 	 crash file:    ..../boofuzz/boofuzz-crash-bin
[04:11.23] 	 # records:     0
[04:11.23] 	 proc name:     None
[04:11.23] 	 log level:     1
[04:11.23] awaiting requests...
```


On another shell, launch the fuzzer with:
```
$ python3 ftp_hpa.py
```

You can check the progress through the shell and the browser at http://localhost:26000


