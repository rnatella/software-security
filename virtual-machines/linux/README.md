1) Installare VirtualBox

2) Installare Vagrant (es. tramite [Brew](https://brew.sh))

3) Utilizzare questi comandi:

```
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-docker-compose
$ vagrant up
$ ./ova-export.sh
```

Per future esecuzioni, aggiornare prima l'immagine di partenza del SO:
```
$ vagrant box update
```
