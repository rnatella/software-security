# Install VMware Fusion

```
brew install --cask vmware-fusion
```


# Install Vagrant VMware Utility

```
brew install --cask vagrant-vmware-utility
```

Or download from https://developer.hashicorp.com/vagrant/install/vmware (macOS AMD64)


# Install Vagrant VMware provider plugin

```
vagrant plugin install vagrant-vmware-desktop
```


# Run Vagrant

```
vagrant up
```


# Export VM

Run `ova-cleanup.sh` from within the VM.
Then:

```
/Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/ovftool  --acceptAllEulas  <VMX-PATH> <OVA-PATH>
```
