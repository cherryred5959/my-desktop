#!/bin/bash

# For Ubuntu 18.0.4 LTS

# Script Option
while getopts w: OPTION
do
  case $OPTION in
    w) WSL2="$OPTARG" ;;
  esac
done

# Kakao Mirror
echo -e "\n[Kakao Mirror]\n"
sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com\/ubuntu/g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get autoremove -y

# Make
echo -e "\n[Make]\n"
sudo apt-get install make build-essential -y

# Docker & Dcoker Compose
echo -e "\n[Docker & Dcoker Compose]\n"
sudo apt-get remove docker docker-engine docker.io -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce -y
sudo usermod -aG docker $USER
if [ "$WSL2" == true ]
then
  sudo systemctl start docker
  sudo systemctl enable docker
else
  sudo service docker start
fi
sudo apt-get install docker-compose -y

# Git
echo -e "\n[Git]]\n"
sudo apt-get install git -y

# ZSH
echo -e "\n[ZSH]\n"
sudo apt-get install zsh -y
sudo sed -i 's/required\s*pam_shells\.so/sufficient    pam_shells\.so/g' /etc/pam.d/chsh
chsh -s $(which zsh)
sudo sed -i 's/sufficient\s*pam_shells\.so/required    pam_shells\.so/g' /etc/pam.d/chsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i 's/plugins\=.*$/plugins\=(git zsh-autosuggestions)/g' ~/.zshrc

# Monit
if [ "$WSL2" == true ]
then
  echo -e "\n[Monit]\n"
  sudo apt-get install monit -y
  sudo echo '%sudo   ALL=NOPASSWD:/usr/sbin/service monit start' | sudo EDITOR='tee -a' visudo
  cat << EOT >> ~/.zshrc
if ! pgrep -f "monit" > /dev/null 2>&1; then
  sudo /usr/sbin/service monit start
fi
EOT
  sudo tee -a /etc/monit/monitrc >/dev/null << EOF
check process docker with pidfile /run/docker/docker.pid
    start program = "/etc/init.d/docker start" with timeout 60 seconds
    stop program  = "/etc/init.d/docker stop"
EOF
fi

# Nimf & Korean Font
if [ "$WSL2" != true ]
then
  echo "\n[Nimf & Korean Font]\n"
  sudo add-apt-repository ppa:hodong/nimf -y
  sudo apt-get update
  sudo apt-get install nimf nimf-libhangul fonts-nanum fonts-nanum-coding fonts-nanum-extra -y
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
fi

# Reboot
if [ "$WSL2" != true ]
then
  echo -e "\n[Reboot]\n"
  reboot
else
  echo -e "\n[ZSH Start]\n"
  zsh
fi

