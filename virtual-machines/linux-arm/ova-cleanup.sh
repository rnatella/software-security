set -xe

# Free space on disk
sudo rm -rf /home/so/.viminfo
sudo rm -rf /home/so/.ssh
sudo rm -rf /home/so/.cache/pip

sudo apt-get clean
sudo apt-get -y autoremove
sudo rm -rf /tmp/*

sudo rm -f /etc/netplan/*-vagrant.yaml

# Zerofill virtual hd to save space when exporting
time sudo dd if=/dev/zero of=/tmp/zero bs=1M || true
sync ; sleep 1 ; sync ; sudo rm -f /tmp/zero

sudo rm -f /home/so/.bash_history
history -c

# Delete vagrant user
sudo userdel -r -f vagrant


