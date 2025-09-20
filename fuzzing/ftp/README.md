# Building and running the vulnerable FTP server

Move to the "ftp-server" folder, and patch and build the FTP server:

```
$ cd ftp-server

$ tar zxf hpaftpd.tgz

$ patch -p1 -d hpaftpd-1.05/ < hpaftpd-debug.patch

$ cd hpaftpd-1.05

$ make CFLAGS="-g"

$ cd ..
```



To test that the FTP server actually works, run this command:
```
$ cd hpaftpd-1.05

$ fakechroot fakeroot ./hpaftpd -l -p2121 -unobody -d../ftp-root/
```

**Note**: For testing purposes, we are running the FTP server in a "fake" chroot jail (using "fakechroot") and "fake" root (using "fakeroot") for de-privileging. Using a real chroot jail and de-privileging would require root privileges, or to use "sudo", which make it more difficult to collect coredumps.


On another shell, try to connect to the FTP server (with "anonymous" both as username and password):
```
$ ftp localhost 2121
Connected to localhost.

220 HighPerfomanceAnonymousFTPServer
Name (localhost:unina): anonymous
331 Password required for anonymous
Password: 

230 User anonymous logged in
Remote system type is UNIX.
Using binary mode to transfer files.

ftp> ls
227 Entering Passive Mode (127,0,0,1,4,0).
150 Open data connection
drwxr-xr-x    2 root root      4096 Sep 19 17:54 .
drwxr-xr-x    2 root root      4096 Sep 19 17:54 ..
-rw-r--r--    1 root root         5 Sep 19 16:13 ciao.txt
226 Transfer complete

ftp> pwd
257 "/" is current work directory.

ftp> quit
221 Goodbye.
```



To **make the FTP server vulnerable**, patch the source code to inject a buffer overflow vulnerability:
```
$ patch -p1 -d hpaftpd-1.05/ < hpaftpd-vulnerable.patch
```

Then, build and run the FTP server again. The server will crash if the command string is too long.

To **remove the vulnerability**, you can reverse the patch with:
```
$ patch -R -p1 -d hpaftpd-1.05/ < hpaftpd-vulnerable.patch
```



# metasploit (generation fuzzing)

Run metasploit with "msfconsole", then use the following commands to enable the fuzzer:
```
$ ./msfconsole

msf6 > search fuzzers

search fuzzers

Matching Modules
================

   #   Name                                            Disclosure Date  Rank    Check  Description
   -   ----                                            ---------------  ----    -----  -----------
   ...
   18  auxiliary/fuzzers/ftp/ftp_pre_post                               normal  No     Simple FTP Fuzzer
   ...

msf6 > use auxiliary/fuzzers/ftp/ftp_pre_post

msf6 > info

       Name: Simple FTP Fuzzer
     Module: auxiliary/fuzzers/ftp/ftp_pre_post
     ...

msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set RHOSTS 127.0.0.1
msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set RPORT  2121
msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set STARTSIZE 1
msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set ENDSIZE 100
msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set STEPSIZE 1000

msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > run

```



# boofuzz (generation fuzzing)

Move to the "boofuzz" folder, and clone the submodule with boofuzz:

```
$ cd boofuzz

$ git submodule update --init --recursive
```

Patch and install boofuzz:

```

$ patch -d boofuzz-fuzzer/ -p1 < boofuzz-isalive.patch

$ cd boofuzz-fuzzer
$ pip3 install .
$ cd ..
```

To perform fuzzing on the FTP server, first run the process monitor.
On crashes of the FTP server, it will store the core dump ("coredumps" folder), and restart the FTP server for the next test.

```
$ ulimit -c unlimited
$ sudo bash -c 'echo core > /proc/sys/kernel/core_pattern'
$ sudo bash -c 'echo 0 > /proc/sys/kernel/core_uses_pid'
$ sudo systemctl disable apport.service

$ python3 boofuzz-fuzzer/process_monitor_unix.py -d ./coredumps

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

You can check the progress through the shell, and through the browser at http://localhost:26000


# mutiny (mutation fuzzing)

Install `scapy`:
```
$ pip3 install scapy
```

Move to the "mutiny" folder, and clone the submodule with mutiny:

```
$ cd mutiny

$ git submodule update --init --recursive
```

Mutiny is built on top of `radamsa`, a command-line fuzzing tool.
To build radamsa:
```
$ cd mutiny-fuzzer

$ tar zxf radamsa-v0.6.tar.gz
$ cd radamsa-v0.6/
$ make
$ cd ..

```

To perform fuzzing through mutation, you need to use an existing FTP traffic trace in PCAP format. You can find in this repo a sample PCAP file.

To print the PCAP on the console:
```
$ tshark -r  ftp.pcap -V
```

If you need to collect your own sample of FTP traffic in PCAP format:
```
$ sudo tcpdump -i lo  -w ftp.pcap "port 2121"
```


Configure the fuzzer with the PCAP file, by running `mutiny_prep.py` as follows.
When it asks for `combine payloads into single messages`, you can reply `n`.
You can select the default for the other questions.
The script will create the file `ftp-0.fuzzer`.
```
$ cd mutiny-fuzzer

$ python3 mutiny_prep.py -a ../ftp.pcap
```

Start the FTP server in another shell.
Then, run the fuzzer:
```
$ python3 mutiny.py ftp-0.fuzzer 127.0.0.1
```


