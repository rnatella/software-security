If you are deploying this lab on your own **Linux** machine, you need to set the lab's hostnames to localhost.

You can add the following lines to `/etc/hosts`:
```
# For XSS Lab
10.9.0.5        www.xsslabelgg.com
10.9.0.5        www.example32a.com
10.9.0.5        www.example32b.com
10.9.0.5        www.example32c.com
10.9.0.5        www.example60.com
10.9.0.5        www.example70.com
```

Changing and saving the file will have immediate effect.

If you are deploying this lab on your own **Mac** machine, you need to set the lab's hostnames to localhost.

Due to the following problem: 

`The docker (Linux) bridge network is not reachable from the macOS host`

you need to uncomment this two lines in the docker-compose file: 

```
# ports:
#     - "80:80"
```
In Addition, you can add the following lines to `/etc/hosts`:
```
# For XSS Lab
127.0.0.1        www.xsslabelgg.com
127.0.0.1        www.example32a.com
127.0.0.1        www.example32b.com
127.0.0.1        www.example32c.com
127.0.0.1        www.example60.com
127.0.0.1        www.example70.com
```
Changing and saving the file will have immediate effect.

For more details check out the documentation: https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds 