# Install VMware Fusion and tools

```
brew install --cask vmware-fusion
```

```
sudo softwareupdate --install-rosetta
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


# Issue with OS type

`ovftool` generates an OVF with guest type set to `otherGuest`. You can fix it as follows:

```
OVA=<OVA-FILENAME>

mkdir ova/
tar xf $OVA -C ova/
cd ova/
perl -p -i -e 's/vmw:osType="\w+"/vmw:osType="armUbuntu64Guest"/' *.ovf
SHA=$(shasum -a 256 *.ovf|awk '{print $1}')
perl -p -i -e 'if(/SHA256\(.*?\.ovf\)/) { s/\s\w+$/ '$SHA'/ }' *.mf

rm ../$OVA
tar -cvf ../$OVA *.ovf *.vmdk *.mf
cd ..
rm -rf ova/
```

Despite this fix, VMware Fusion still imports the VM as "Other" type.
The correct type can be configured in the settings of the VM, under `General`.
