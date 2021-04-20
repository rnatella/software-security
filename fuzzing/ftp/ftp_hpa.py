#!/usr/bin/env python3
# Designed for use with boofuzz v0.2.0

from boofuzz import *


def main():
    """
    This example is a very simple FTP fuzzer using a process monitor (procmon).
    It assumes that the procmon is already running. The script will connect to
    the procmon and tell the procmon to start the target application
    (see start_cmd).

    The ftpd.py in `start_cmd` is a simple FTP server using pyftpdlib. You can
    substitute any FTP server.
    """
    target_ip = "127.0.0.1"
    start_cmd = ["./hpaftpd-1.05/hpaftpd", "-p2121", "-l", "-unobody"]

    # initialize the process monitor
    # this assumes that prior to starting boofuzz you started the process monitor
    # RPC daemon!
    procmon = ProcessMonitor(target_ip, 26002)
    procmon.set_options(start_commands=[start_cmd])

    # We configure the session, adding the configured procmon to the monitors.
    # fmt: off
    session = Session(
        target=Target(
            connection=TCPSocketConnection(target_ip, 2121),
            monitors=[procmon],
        ),
        sleep_time=0.2,
    )
    # fmt: on

    s_initialize("user")
    s_string("USER", fuzzable=False)
    s_delim(" ", fuzzable=False)
    s_string("anonymous", fuzzable=False)
    s_static("\r\n")

    s_initialize("pass")
    s_string("PASS", fuzzable=False)
    s_delim(" ", fuzzable=False)
    s_string("james", fuzzable=False)
    s_static("\r\n")

    s_initialize("list")
    s_string("LS")
    s_delim(" ")
    s_string("AAAA")
    s_static("\r\n")

    s_initialize("recv")
    s_string("RECV")
    s_delim(" ")
    s_string("AAAA")
    s_delim(" ")
    s_string("BBBB")
    s_static("\r\n")


    session.connect(s_get("user"))
    session.connect(s_get("user"), s_get("pass"))
    session.connect(s_get("pass"), s_get("list"))
    session.connect(s_get("pass"), s_get("recv"))

    session.fuzz()


if __name__ == "__main__":
    main()
