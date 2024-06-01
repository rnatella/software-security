# Building and running the vulnerable FTP server

Patch and build the FTP server:

```
$ tar zxf hpaftpd.tgz

$ patch -p1 -d hpaftpd-1.05/ < hpaftpd-debug.patch

$ cd hpaftpd-1.05

$ make CFLAGS="-g"

$ cd ..
```



To test that the FTP server actually works, run this command:
```
$ ./hpaftpd-1.05/hpaftpd -p2121  -l -unobody
```

**Note**: To make it easier to run and fuzz the server, we are running the FTP server without chroot jailing and without de-privileging.


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



To **make the FTP server vulnerable**, patch the source code to inject a vulnerability:
```
$ patch -p1 -d hpaftpd-1.05/ < hpaftpd-vulnerable.patch
```

Then, build and run the FTP server again. The server will crash if the command string is too long.

To **remove the vulnerability**, you can reverse the patch with:
```
$ patch -R -p1 -d hpaftpd-1.05/ < hpaftpd-vulnerable.patch
```



# metasploit (generation fuzzing)

To install metasploit on Ubuntu 22.04:

```
$ sudo apt install gem ruby-rubygems
$ sudo gem update

$ sudo apt install ruby-dev ruby-pg libpq-dev libpcap-dev libsqlite3-dev

$ git clone https://github.com/rapid7/metasploit-framework.git

$ cd metasploit-framework/
$ sudo gem install bundler
$ bundle install
```


Then, run metasploit with:
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

The version of boofuzz in this repo works with Python3 up to version 3.9.
If you have a more recent version, you can use `pyenv` to run version 3.9.
To install `pyenv`, see the instructions at the end of this guide.
To install and to switch to Python 3.9.16 (only in the current working directory):

```
$ pyenv install 3.9.16

$ pyenv local 3.9.16
```

Clone the submodule with boofuzz:

```
$ git submodule update --init --recursive
```

Patch and install boofuzz:

```
$ patch -d boofuzz/ -p1 < boofuzz-isalive.patch

$ cd boofuzz
$ pip3 install .
$ cd ..
```

To perform fuzzing on the FTP server, first run the process monitor.
On crashes of the FTP server, it will store the core dump, and restart the FTP server for the next test.

```
$ ulimit -c unlimited
$ sudo bash -c 'echo core > /proc/sys/kernel/core_pattern'
$ sudo bash -c 'echo 0 > /proc/sys/kernel/core_uses_pid'
$ sudo systemctl disable apport.service

$ python3 boofuzz/process_monitor_unix.py

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

Clone mutiny from:

```
$ git clone https://github.com/Cisco-Talos/mutiny-fuzzer
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

To perform fuzzing through mutation, you need to collect a sample of FTP traffic in PCAP format:
```
$ sudo tcpdump -i lo  -w ftp.pcap "port 2121"
```

You can find in this repo a sample PCAP file.
To print the PCAP on the console:
```
$ tshark -r  ftp.pcap -V
```

Configure the fuzzer with the PCAP file, by running `mutiny_prep.py` as follows.
When it asks for `combine payloads into single messages`, you can reply `n`.
You can select the default for the other questions.
The script will create the file `ftp-0.fuzzer`.
```
$ cd mutiny-fuzzer

$ python mutiny_prep.py -a ../ftp.pcap
```

Start the FTP server in another shell.
Then, run the fuzzer:
```
$ python mutiny.py ftp-0.fuzzer 127.0.0.1
```


# Pyenv

To install Pyenv:
```
curl https://pyenv.run | bash
```

Put the following in `~/.bash_profile`:
```
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

Put the following in `~/.bashrc`:
```
eval "$(pyenv virtualenv-init -)"
```

Log-out and then log-in again. Check that Pyenv works with:
```
pyenv install --list
```

You can install an additional Python version with:
```
pyenv install 2.7.18
```

To switch to a specific version (only in the current working dir):
```
pyenv local 2.7.18
```

On Ubuntu 22.04, you may need to install extern dependencies for Python, such as:
```
$ sudo apt install libssl-dev libsqlite3-dev
```

