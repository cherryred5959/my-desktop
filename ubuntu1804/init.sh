#! /bin/bash

# For Ubuntu 18.0.4 LTS

# Kakao Mirror
sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com\/ubuntu/g' /etc/apt/sources.list 
sudo apt-get update

# Nimf & Korean Font
sudo add-apt-repository ppa:hodong/nimf -y
sudo apt-get update
sudo apt-get install nimf nimf-libhangul fonts-nanum fonts-nanum-coding fonts-nanum-extra -y

# Docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get install docker-compose -y

# Git
sudo apt-get install git

# Keyboard
sudo cp ./xkorkeymap /usr/bin/xkorkeymap
sudo chmod +x /usr/bin/xkorkeymap
mkdir -p ~/.config/autostart
cat << EOF | tee ~/.config/autostart/xkorkeymap.desktop
[Desktop Entry]
Type=Application
Name=Xkorkeymap
Comment=xkorkeymap
Exec=/usr/bin/xkorkeymap
X-GNOME-Autostart-Delay=10
X-MATE-Autostart-Delay=10
X-KDE-autostart-after=panel
X-GNOME-Autostart-enabled=true
EOF

chmod +x ~/.config/autostart/xkorkeymap.desktop

reboot