If you are deploying this lab on your own **Linux** machine, you need to set the lab's hostnames to localhost.

You can add the following lines to `/etc/hosts`:
```
# For CSRF Lab
10.9.0.5        www.csrflabelgg.com
10.9.0.5        www.csrflab-defense.com
10.9.0.105      www.csrflab-attacker.com
```

Changing and saving the file will have immediate effect.

If you are deploying this lab on your own **Mac** machine, you need to set the lab's hostnames to localhost.
Due to following problem: 
`The docker (Linux) bridge network is not reachable from the macOS host.`
you need to uncomment lines regarding ports in the docker-compose file. 

In Addition, you can add the following lines to `/etc/hosts`:
```
# For CSRF Lab
127.0.0.1        www.csrflabelgg.com
127.0.0.1        www.csrflab-defense.com
127.0.0.1      www.csrflab-attacker.com
```

Changing and saving the file will have immediate effect. 

P.S: you need to use the port 8080 in order to successfully connect to the www.csrflab-attacker.com site.

For more details check out the documentation: https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds 