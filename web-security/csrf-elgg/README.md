# Troubleshooting

Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for suggestions to fix problems.

# Running the lab on Linux

If you are deploying this lab on your own **Linux** machine, you need to set the lab's hostnames to localhost.

You can add the following lines to `/etc/hosts`:
```
# For CSRF Lab
10.9.0.5        www.csrflabelgg.com
10.9.0.5        www.csrflab-defense.com
10.9.0.105      www.csrflab-attacker.com
```

Changing and saving the file will have immediate effect.

# Running the lab on MacOS X

If you are deploying this lab on your own **Mac** machine, you need to set the lab's hostnames to localhost.

Due to the following problem: 

`The docker (Linux) bridge network is not reachable from the macOS host`

you need to uncomment lines regarding ports in the docker-compose file. 

In addition, you can add the following lines to `/etc/hosts`:
```
# For CSRF Lab
127.0.0.1        www.csrflabelgg.com
127.0.0.1        www.csrflab-defense.com
127.0.0.1      www.csrflab-attacker.com
```

Changing and saving the file will have immediate effect. 

P.S: you need to use the port 8080 in order to successfully connect to the www.csrflab-attacker.com site.

In order to run the example about cookies following **www.csrflab-defense.com** link, you have to modify in image_www/defense/index.php the following line:

`<h2>Experiment B: click <a href="http://www.csrflab-attacker.com/testing.html">Link B</a></h2>`

and add the port number assigned in docker-compose file (in this case 8080)

`<h2>Experiment B: click <a href="http://www.csrflab-attacker.com:8080/testing.html">Link B</a></h2>`


For more details check out the documentation: https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds 
