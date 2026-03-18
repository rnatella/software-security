#!/bin/bash

# Disable configuration wizards in apt (use defaults)
export DEBIAN_FRONTEND=noninteractive

export USERNAME="swsec"
export PASSWORD="swsec"


# Create user
adduser --disabled-password --gecos "" $USERNAME
echo "$USERNAME:$PASSWORD"|chpasswd

# Add user to sudoers, disable password
usermod -a -G sudo $USERNAME
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# Install updates
apt-get update
apt-get upgrade -y


# Install Ubuntu Desktop
apt-get install -y --no-install-recommends ubuntu-desktop


# Set automatic login for user
perl -p -i -e 's/#\s*AutomaticLogin/AutomaticLogin/' /etc/gdm3/custom.conf
perl -p -i -e "s/AutomaticLogin\s=\s\w+/AutomaticLogin = $USERNAME/" /etc/gdm3/custom.conf


# Install Italian language support for Ubuntu, set locale
apt-get install -y language-pack-it language-pack-gnome-it language-pack-it-base language-pack-gnome-it-base
update-locale LANG=it_IT.UTF-8 LANGUAGE= LC_MESSAGES= LC_COLLATE= LC_CTYPE=


# Timezone
timedatectl set-timezone Europe/Rome


# Install guest OS tools
apt-get install -y build-essential
apt-get install -y linux-headers-$(uname -r)
apt-get install -y virtualbox-guest-utils virtualbox-guest-x11
#apt-get install -y virtualbox-dkms virtualbox-guest-additions-iso
apt-get install -y open-vm-tools open-vm-tools-desktop


# Guest OS tools for QEMU
#https://www.snel.com/support/nstall-qemu-guest-agent-for-debian-ubuntu/
#apt-get install -y qemu-guest-agent
#systemctl enable qemu-guest-agent
#systemctl start qemu-guest-agent


# Install basic tools for C/C++ development
apt-get install -y gcc-multilib g++-multilib \
                   git \
                   gdb \
                   autoconf \
                   libtool \
                   valgrind \
                   vim \
                   man-db \
                   manpages-posix \
                   manpages-dev \
                   manpages-posix-dev \
                   llvm \
                   lldb \
                   clang \
                   cmake



# Install misc Ubuntu apps
apt-get install -y fonts-ubuntu \
                   curl \
                   wget \
                   tree \
                   dos2unix \
                   expect \
                   net-tools \
                   network-manager \
                   network-manager-gnome \
                   jq \
                   python3-pip \
                   hunspell-it \
                   witalian \
                   evince \
                   file-roller \
                   gedit \
                   gnome-system-monitor \
                   gnome-logs \
                   eog \
                   eog-plugins


# was: ttf-ubuntu-font-family

systemctl restart gdm3


snap install snap-store

snap install firefox

#snap install teams-for-linux

snap install chromium


# Misc packages for examples from lectures
apt-get install -y cgroup-tools \
                   openjdk-21-jdk


# Install basic web development and hacking tools
apt-get install -y php-cli \
                   python3-pip \
                   golang-go \
                   apache2 \
                   ufw \
                   nmap \
                   sqlmap \
                   wireshark \
                   tshark \
                   tcpick \
                   tweak \
                   python3-venv \
                   sqlite

apt-get install -y moreutils	# sponge


pip3 install flask

systemctl disable apache2
systemctl stop apache2


# User configuration files
su - $USERNAME -c "touch /home/$USERNAME/.bash_profile"
su - $USERNAME -c "touch /home/$USERNAME/.bashrc"


snap install ngrok
#snap install zaproxy --classic
#snap install hetty
snap install metasploit-framework

pip3 install pwntools

su - $USERNAME -c 'touch ~/.pwn.conf'
cat <<'EOF' >>/home/$USERNAME/.pwn.conf
[update]
interval=never
EOF

apt install -y python3-requests python3-bs4 python3-scapy


# Install AFL++ for fuzzing labs
apt install -y afl++
apt install -y libstdc++-12-dev


# Install fakechroot and fakeroot for running FTP server for fuzzing
apt install -y fakechroot fakeroot


# Install pyenv (dependency for basic fuzzing examples)

#apt install -y zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev tk-dev

#su - $USERNAME -c "curl https://pyenv.run | bash"

#cat <<'EOF' >>/home/$USERNAME/.bash_profile
#export PYENV_ROOT="$HOME/.pyenv"
#[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#EOF

#cat <<'EOF' >>/home/$USERNAME/.bashrc
#
#eval "$(pyenv virtualenv-init -)"
#
#EOF

#su - $USERNAME -c 'source ~/.bash_profile && pyenv install 3.9.16'



# Path for pwntools utilities at command line
echo 'export PATH=$PATH:~/.local/bin/' >> /home/$USERNAME/.bash_profile


# Install Pwndbg for buffer overflow labs
# (uses "sudo", we previously disabled the password prompt)
su - $USERNAME -c "touch /home/$USERNAME/.gdbinit"
su - $USERNAME -c 'git clone https://github.com/pwndbg/pwndbg && cd pwndbg && DEBIAN_FRONTEND=noninteractive ./setup.sh'
echo "set show-tips off" >>/home/$USERNAME/.gdbinit


# Install Visual Studio Code and its C/C++ extension
snap install --classic code
su - $USERNAME -c 'code --install-extension ms-vscode.cpptools'

# Default settings for Visual Studio Code (hide ".vscode" folder, disable workspace trust)
su - $USERNAME -c "mkdir -p /home/$USERNAME/.config/Code/User && touch /home/$USERNAME/.config/Code/User/settings.json"

cat <<EOF >/home/$USERNAME/.config/Code/User/settings.json
{
    "security.workspace.trust.enabled": false,
    "files.exclude": {
        "**/.vscode": true
    },
    "extensions.ignoreRecommendations": true,
    "extensions.autoCheckUpdates": false,
    "extensions.autoUpdate": false,
    "update.mode": "none",
    "workbench.startupEditor": "none",
    "window.restoreWindows": "none"
}
EOF


# Disable keyring prompt at start of VSCode
if [ -e .vscode/argv.json ]
then
    sed '/^[[:blank:]]*#/d;s/\/\/.*//'  /home/$USERNAME/.vscode/argv.json | jq '."password-store"="basic"' | sponge /home/$USERNAME/.vscode/argv.json
else
    su - $USERNAME -c "touch /home/$USERNAME/.vscode/argv.json"
    echo '{ "password-store": "basic" }' >> /home/$USERNAME/.vscode/argv.json
fi


# Install CodeQL CLI
wget `curl -s https://api.github.com/repos/github/codeql-cli-binaries/releases/latest | jq '.assets[] | select(.name|match("codeql-linux64.zip$")) | .browser_download_url' | tr -d \"`
unzip codeql-linux64.zip
mv codeql /opt/
rm codeql-linux64.zip


# Install VSCode extension for CodeQL

su - $USERNAME -c 'code --install-extension GitHub.vscode-codeql'

su - $USERNAME -c "jq '.\"codeQL.cli.executablePath\" = \"/opt/codeql/codeql\"' /home/$USERNAME/.config/Code/User/settings.json | sponge /home/$USERNAME/.config/Code/User/settings.json"
su - $USERNAME -c "jq '.\"codeQL.addingDatabases.addDatabaseSourceToWorkspace\" = true' /home/$USERNAME/.config/Code/User/settings.json | sponge /home/$USERNAME/.config/Code/User/settings.json"


# Install VSCode workspace for CodeQL
su - $USERNAME -c "git clone --recursive https://github.com/github/vscode-codeql-starter.git"
# to update: git submodule update --remote


# Create desktop shortcut for CodeQL
wget https://raw.githubusercontent.com/github/vscode-codeql/refs/heads/main/extensions/ql-vscode/media/VS-marketplace-CodeQL-icon.png
mv VS-marketplace-CodeQL-icon.png /usr/share/pixmaps/codeql.png

cat <<EOF >/usr/share/applications/codeql.desktop
[Desktop Entry]
Name=CodeQL for Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=wmclass.sh CodeQL codeql /usr/share/code/code /home/$USERNAME/vscode-codeql-starter/vscode-codeql-starter.code-workspace
Icon=codeql
Type=Application
StartupWMClass=CodeQL
StartupNotify=false
Categories=TextEditor;Development;IDE;
MimeType=application/x-code-workspace;
Keywords=vscode;
EOF

pip install --no-input getgist
apt -y install wmctrl

getgist -y rnatella wmclass.sh
chmod +x wmclass.sh
mv wmclass.sh /usr/local/bin/

# Disable CodeQL extension when running VSCode without the workspace
perl -p -i -e 'if(/^Exec/) { s/$/ --disable-extension GitHub.vscode-codeql/; }' /usr/share/applications/code.desktop


# Java dependencies for CodeQL demo
apt install -y maven


# Other static code analyzers

pip3 install semgrep

mkdir /opt/joern
cd /opt/joern
curl -L "https://github.com/joernio/joern/releases/latest/download/joern-install.sh" -o joern-install.sh
chmod u+x joern-install.sh
./joern-install.sh
rm -f joern-install.sh
cd -



# Install Docker
apt-get install -y ca-certificates gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

groupadd docker
usermod -a -G docker $USERNAME


# Install PowerShell
apt-get install -y wget apt-transport-https software-properties-common
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
apt-get update
apt-get install -y powershell



# Install misc Linux debugging tools
apt-get install -y linux-tools-common
apt-get install -y linux-tools-$(uname -r)


# Install password manager for GIT
apt-get install -y libsecret-tools libsecret-common libsecret-1-0 libsecret-1-dev
wget `curl -s https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest| jq '.assets[] | select(.name|match("gcm-linux_amd64.*deb$")) | .browser_download_url' | tr -d \"`
dpkg -i gcm-linux_amd64.*.deb
rm -f gcm-linux_amd64.*.deb

su - $USERNAME -c 'git-credential-manager configure'
su - $USERNAME -c 'git config --global credential.credentialStore secretservice'



# Install Firefox from PPA maintained by Mozilla, replace the snap version to prevent auto-updates
# https://askubuntu.com/questions/1399383/how-to-install-firefox-as-a-traditional-deb-package-without-snap-in-ubuntu-22/1404401#1404401
#add-apt-repository -y ppa:mozillateam/ppa
#cat <<EOF >/etc/apt/preferences.d/mozilla-firefox
#Package: *
#Pin: release o=LP-PPA-mozillateam
#Pin-Priority: 1001
#
#Package: firefox
#Pin: version 1:1snap1-0ubuntu2
#Pin-Priority: -1
#EOF

#snap remove firefox
#apt update
#apt install -y firefox firefox-locale-it  --allow-downgrades


# Prevent snap updates
snap refresh --hold



# Disable unused folder in the home (Music, Templates, Videos, etc)
perl -p -i -e 's/^(TEMPLATES=)/#$1/' /etc/xdg/user-dirs.defaults
perl -p -i -e 's/^(PUBLICSHARE=)/#$1/' /etc/xdg/user-dirs.defaults
perl -p -i -e 's/^(MUSIC=)/#$1/' /etc/xdg/user-dirs.defaults
perl -p -i -e 's/^(PICTURES=)/#$1/' /etc/xdg/user-dirs.defaults
perl -p -i -e 's/^(VIDEOS=)/#$1/' /etc/xdg/user-dirs.defaults



# Enable password authentication with SSHd
perl -p -i -e 's/PasswordAuthentication\s\w+/PasswordAuthentication yes/' /etc/ssh/sshd_config
perl -p -i -e 's/ChallengeResponseAuthentication\s\w+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config



# Install "dbus-launch" (to change the GNOME settings)
apt-get install -y dbus-x11



# Modify "favorite apps" on the dock bar (on the left)
su - $USERNAME -c "dbus-launch gsettings set org.gnome.shell favorite-apps \"['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'firefox.desktop', 'codeql.desktop']\""



# Disable the screensaver
su - $USERNAME -c "dbus-launch gsettings set org.gnome.desktop.session idle-delay 0"
su - $USERNAME -c "dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'"


# Set region and keyboard layout for GNOME
su - $USERNAME -c "dbus-launch gsettings set org.gnome.system.locale region 'it_IT.utf8'"
su - $USERNAME -c "dbus-launch gsettings set org.gnome.desktop.input-sources sources \"[('xkb', 'it')]\""


# Set dark theme
apt-get install -y yaru-theme-gtk yaru-theme-gnome-shell

su - $USERNAME -c "dbus-launch gsettings set org.gnome.shell.ubuntu color-scheme prefer-dark"
su - $USERNAME -c "dbus-launch gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark"
su - $USERNAME -c "dbus-launch gsettings set org.gnome.desktop.interface color-scheme prefer-dark"

su - $USERNAME -c "dbus-launch gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/jj_dark_by_Hiking93.jpg'"


# Set Firefox configuration

# NOTE: Cross-site cookies will be ENABLED to
# make the CSRF attack easier to reproduce

su - $USERNAME -c '(firefox --headless &); sleep 10 && killall firefox'

FIREFOX_CONFIG_DIR=`echo /home/$USERNAME/snap/firefox/common/.mozilla/firefox/*.default/`
FIREFOX_CONFIG_USER=$FIREFOX_CONFIG_DIR/user.js

su - $USERNAME -c "touch ${FIREFOX_CONFIG_USER}"

cat <<EOF >$FIREFOX_CONFIG_USER
user_pref("browser.contentblocking.category", "custom");
user_pref("network.cookie.cookieBehavior", 0);
user_pref("browser.aboutwelcome.didSeeFinalScreen", true);
user_pref("browser.translations.panelShown", true);
user_pref("browser.translations.automaticallyPopup", false);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("security.sandbox.warn_unprivileged_namespaces", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false); 
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("network.trr.mode", 5);
EOF



# Avoid 120s timeout on boot
# https://askubuntu.com/questions/972215/a-start-job-is-running-for-wait-for-network-to-be-configured-ubuntu-server-17-1
systemctl disable systemd-networkd-wait-online.service
systemctl mask systemd-networkd-wait-online.service

# Widget for showing IP address
#add-apt-repository -y ppa:nico-marcq/indicator-ip
#apt-get update
#apt-get install -y python3-indicator-ip gir1.2-appindicator3-0.1


# GRUB vanilla defaults
rm /etc/default/grub.d/50-cloudimg-settings.cfg



# Setup hostnames for SEED security labs

cat <<EOF >>/etc/hosts

# For web security labs

10.9.0.5        www.seed-server.com

10.9.0.5        www.example32a.com
10.9.0.5        www.example32b.com
10.9.0.5        www.example32c.com
10.9.0.5        www.example60.com
10.9.0.5        www.example70.com

10.9.0.5        www.example32.com
10.9.0.105      www.attacker32.com

EOF


# Disable automatic updates for Ubuntu (to prevent that they break the labs)
# https://askubuntu.com/questions/1322292/how-do-i-turn-off-automatic-updates-completely-and-for-real
cat <<EOF >/etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF


# Re-enable password for sudo
perl -p -i -e '$_=undef if(/^'$USERNAME' ALL=\(ALL\)\sNOPASSWD:/)' /etc/sudoers


# Setup Git repo with class materials
su - $USERNAME -c "git clone https://github.com/rnatella/software-security && cd software-security && git submodule update --init --recursive"

su - $USERNAME -c "cd /home/$USERNAME/software-security/static-analysis/codeql-uboot && wget https://github.com/github/securitylab/releases/download/u-boot-codeql-database/u-boot_u-boot_cpp-srcVersion_d0d07ba86afc8074d79e436b1ba4478fa0f0c1b5-dist_odasa-2019-07-25-linux64.zip"


jq '.folders |= . + [{"path": "../software-security/static-analysis/codeql-query"}]' /home/$USERNAME/vscode-codeql-starter/vscode-codeql-starter.code-workspace | sponge /home/$USERNAME/vscode-codeql-starter/vscode-codeql-starter.code-workspace
jq '.folders |= . + [{"path": "../software-security/static-analysis/codeql-boot"}]' /home/$USERNAME/vscode-codeql-starter/vscode-codeql-starter.code-workspace | sponge /home/$USERNAME/vscode-codeql-starter/vscode-codeql-starter.code-workspace


# Build containers for labs
su - $USERNAME -c "cd ~/software-security/web-security/xss-elgg && docker compose build"
su - $USERNAME -c "cd ~/software-security/web-security/csrf-elgg && docker compose build"
su - $USERNAME -c "cd ~/software-security/web-security/sql-injection && docker compose build"
su - $USERNAME -c "cd ~/software-security/web-security/session-hijacking && docker compose build"





# Remove unneeded packages
apt-get update
apt-get autoremove -y




# Set DHCP for all virtual Ethernet NICs
#cat <<EOF >/etc/systemd/network/99-wildcard.network
#[Match]
#Name=en*
#
#[Network]
#DHCP=yes
#EOF

# Set DHCP for all virtual Ethernet NICs (Netplan)
# https://askubuntu.com/questions/1312096/wired-network-settings-missing-in-ubuntu-desktop-20-10
# https://serverfault.com/questions/923328/is-there-a-way-to-automatically-add-network-interfaces-to-systemd-networkd-and-o
# https://askubuntu.com/questions/1373687/automatic-network-card-configuration
# https://askubuntu.com/questions/71159/network-manager-says-device-not-managed
# https://askubuntu.com/questions/1290471/ubuntu-ethernet-became-unmanaged-after-update
rm -f /etc/netplan/*.yaml
cat <<EOF >/etc/netplan/01-wildcard.yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    all-en-1:
      match:
        name: "en*"
      dhcp4: true
    all-en-2:
      match:
        name: "en*"
      dhcp4: true
EOF

chmod 600 /etc/netplan/01-wildcard.yaml

perl -p -i -e 's/managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf

echo > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf

netplan generate
netplan apply


shutdown -r now

