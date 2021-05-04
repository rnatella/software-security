# Installing the vulnerable FTP server

Patch and build the (vulnerable) FTP server:

```
$ tar zxf hpaftpd.tgz

$ cd hpaftpd-1.05

$ patch -p1 < hpaftpd-debug.patch

$ make CFLAGS="-g"

$ cd ..
```


To test that the FTP server actually works, run this command:
```
$ ./hpaftpd-1.05/hpaftpd -p2121  -l -unobody
```

**Note**: To make it easier to run and fuzz the server, we are not running the FTP with chroot jailing and de-privileging.


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
drwx------    2 root root     16384 Sep 27 18:53 lost+found
drwxr-xr-x    2 root root      4096 Jul 31 18:27 mnt
....
226 Transfer complete

ftp> pwd
257 "/" is current work directory.

ftp> quit
221 Goodbye.
```





# metasploit (generation fuzzing)

To install metasploit on Ubuntu 20.04:

```
$ sudo apt install gem
$ sudo gem update

$ sudo apt install ruby-dev
$ sudo apt install ruby-pg
$ sudo apt install libpq-dev
$ sudo apt install libpcap-dev
$ sudo apt-get install libsqlite3-dev

$ git clone https://github.com/rapid7/metasploit-framework.git

$ cd metasploit-framework/
$ sudo gem install bundler
$ bundle install
```


Then, run metasplot with:
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

msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set RHOSTS 127.0.0.1
msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > set RPORT  2121
msf6 auxiliary(fuzzers/ftp/ftp_pre_post) > run

```



# boofuzz (generation fuzzing)

Clone, patch, and install boofuzz from GitHub:

```
$ git submodule update --init --recursive

$ patch -d boofuzz -p1 < boofuzz-isalive.patch

$ cd boofuzz
$ pip3 install .
$ cd ..
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


# mutiny (mutation fuzzing)

Note: this tool still runs on Python 2.
To install Python 2 on Ubuntu 20.04:

```
$ sudo apt install python2

$ curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py

$ sudo python2 get-pip.py

$ pip2 install scapy
```

First, build the radamsa tool (used by mutiny):
```
$ git clone https://github.com/Cisco-Talos/mutiny-fuzzer

$ cd mutiny-fuzzer

$ tar zxf radamsa-v0.6.tar.gz
$ cd radamsa-v0.6/
$ make
$ cd ..

```

To perform fuzzing through mutation, you need to collect a sample of FTP traffic in PCAP format:
```
$ sudo tcpdump -i lo  -w ftp.pcap "port 2121"
```

To run the fuzzer:
```
$ python2 mutiny_prep.py -a ftp.pcap

$ python2 mutiny.py ftp-0.fuzzer 127.0.0.1
```

