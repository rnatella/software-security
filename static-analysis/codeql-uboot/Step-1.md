## Welcome to the CodeQL U-Boot Challenge for C/C++

We created this course to help you quickly learn CodeQL, our query language and engine for code analysis. The goal is to find several remote code execution (RCE) vulnerabilities in the open-source software known as U-Boot, using CodeQL and its libraries for analyzing C/C++ code. To find the real vulnerabilities, you'll need to write a sequence of queries, making them more precise at each step of the course.

### More detail

The goal is to find a set of 9 remote-code-execution vulnerabilities in the U-Boot boot loader. These vulnerabilities were originally discovered by GitHub Security Lab researchers and have since been fixed. An attacker with positioning on the local network, or control of a malicious NFS server, could potentially achieve remote code execution on the U-Boot powered device. This was possible because the code read data from the network (that could be attacker-controlled) and passed it to the length parameter of a call to the `memcpy` function. When such a length parameter is not properly validated before use, it may lead to exploitable memory corruption vulnerabilities.

U-Boot contains hundreds of calls to both `memcpy` and `libc` functions that read data from the network. You can often recognize network data being acted upon through use of the `ntohs` (network to host short) and `ntohl` (network to host long) functions or macros. These swap the byte ordering for integer values that are received in network ordering to the host's native byte ordering (which is architecture dependent).

In this course, you will use [CodeQL](https://codeql.com) to find such calls. Many of those calls may actually be safe, so throughout this course you will refine your query to reduce the number of false positives, and finally track down the unsafe calls to `memcpy` that are influenced by remote input.

Upon completion of the course, you will have created a CodeQL query that is able to find variants of this common vulnerability pattern.

## Step 1: Know where to get help

Bookmark these useful documentation links:

- [Writing a basic C++ Code QL query](https://lgtm.com/help/lgtm/console/ql-cpp-basic-example)
- [Introduction to CodeQL](https://codeql.github.com/docs/writing-codeql-queries/introduction-to-ql/)
- [CodeQL Docs](https://codeql.github.com/docs/) 

Hope this is exciting! Go ahead with the next step in this series.


