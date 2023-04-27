### Create VM with Vagrant ###
https://github.com/Baune8D/packer-windows-desktop
https://app.vagrantup.com/baunegaard/boxes/win10pro-en

For using VirtualBox:
```
VAGRANT_VAGRANTFILE=Vagrantfile.virtualbox vagrant up
```

For using VMware Player/Fusion:
```
git clone https://github.com/hashicorp/vagrant-vmware-desktop/
cd vagrant-vmware-desktop
cd go_src/vagrant-vmware-utility
go build
./vagrant-vmware-utility certificate generate

<prints a path, put it in environment var>

export VMWARE_API_CERT_PATH="./vagrant-vmware-desktop/go_src/vagrant-vmware-utility/certificates"

sudo ./vagrant-vmware-utility api
```

In another terminal:
```
vagrant plugin install vagrant-vmware-desktop

VAGRANT_VAGRANTFILE=Vagrantfile.vmware vagrant up --provider vmware_desktop
```



### Optimize system, remove bloat ###

https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/tree/357ec70f454c53f1adb2e13331d39f2e5e02da54

From PowerShell Core:
```
cd Virtual-Desktop-Optimization-Tool
.\Windows_VDOT.ps1 -Optimizations All -AdvancedOptimizations Edge, RemoveOneDrive -AcceptEULA -Verbose
```

(https://github.com/Fahim732/Windows-10-optimize-script)
```
cd Windows-10-optimize-script
.\optimize.bat
```

The second script reboots the machine.


### Create user (unina/unina), with automated logon ###

https://gist.github.com/ducas/3a65704a3b92dfa0301e

```
& NET USER "unina" "unina" /add /y /expires:never
& NET LOCALGROUP "Administrators" "unina" /add
& WMIC USERACCOUNT WHERE "Name='unina'" SET PasswordExpires=FALSE

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultUserName" /t REG_SZ /d "unina" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultPassword" /t REG_SZ /d "unina" /f
```




### Windows Defender ###
https://www.tenforums.com/tutorials/3569-turn-off-real-time-protection-microsoft-defender-antivirus.html

```
Set-MpPreference -DisableRealtimeMonitoring 1

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name "Real-Time Protection"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord
```


### Firewall ###
```
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```



### Install WinGet (from Microsoft Store) ###
https://www.microsoft.com/p/app-installer/9nblggh4nns1


### Install new PowerShell ###
```
winget install --id Microsoft.Powershell --source winget
```


### Configure keyboard layout (Italian) ###

```
Import-Module -Name International -UseWindowsPowerShell -Verbose
Set-WinUserLanguageList -Force 'it-IT'
```

### Install Chocolatey (from Admin shell) ###
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```


### Install Windows Terminal ###
https://aka.ms/terminal

Install from Microsoft Store.


### Install tools
```
choco install -y winrar
```

###### ...install idafree...
###### ...copy yarGen, sigma, zircolite ....


```
choco install -y ghidra x64dbg.portable dnspy ollydbg sysinternals hxd die pesieve pebear 7zip putty wireshark winpcap fiddler notepadplusplus vscode
```

broken: `choco install -y windows-sdk-10-version-1903-windbg`
broken: `choco install -y processhacker dependencywalker regshot`




### Disable updates ###
```
sc.exe stop wuauserv
sc.exe config wuauserv start=disabled
sc.exe query wuauserv
```




### Scoop (package manager) ###
```
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"

scoop install curl
scoop install python
scoop install pyenv
scoop install rust
scoop install openssh
scoop install git
scoop install vim
```



### Sigma Python deps ###
```
pip install pipenv
pipenv install
```

### Zircolite Python deps ###
```
pip3 install -r requirements.txt
```



### Remove vagrant shared folder ###

For VirtualBox, from host shell:

```
export VM_UUID=`cat .vagrant/machines/default/virtualbox/id`

VBoxManage sharedfolder remove ${VM_UUID} --name vagrant
```

Or, change VM settings in VirtualBox or VMware.



### Disable vagrant user ###
```
Disable-LocalUser -Name vagrant
```




### Remove cli history ###
```
Remove-Item (Get-PSReadlineOption).HistorySavePath

[Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
```




### Misc options ###
https://github.com/Baune8D/vagrant-vs-devbox/

```
Write-Host "Disabling hibernation"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name HibernateFileSizePercent -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name HibernateEnabled -Value 0 -Type DWord

Write-Host "Disabling screensaver"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord

Write-Host "Disabling monitor timeout"
& powercfg -x -monitor-timeout-ac 0
& powercfg -x -monitor-timeout-dc 0

Write-Host "Setting Windows Explorer options"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 -Type DWord
```





### Disk cleanup ###

Delete redundant files:
```
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
```

Zeroing empty disk space, for better compression (https://download.sysinternals.com/files/SDelete.zip)

```
sdelete -z c:
```



### Export OVA ###

For VirtualBox:
```
export VM_UUID=`cat .vagrant/machines/default/virtualbox/id`

VBoxManage export ${VM_UUID} -o Malware-VM.ova
```

For VMware Fusion (Mac):
```
/Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/ovftool --acceptAllEulas <VM PATH>/<VM NAME>.vmwarevm/<VM NAME>.vmx  <DESTINATION PATH>
```
