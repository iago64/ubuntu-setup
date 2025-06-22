set -e

# Update
sudo apt update -y 

# Paquetes Herramientas
sudo apt install -y aptitude vim emacs nano strace ssh curl htop tree wget terminator xclip neofetch net-tools valgrind meld blueman

# Lenguajes de Programacion
sudo apt install -y build-essential autotools-dev gcc gdb g++ python3 python3-pip openjdk-21-jdk openjdk-21-jre libcunit1-dev libcunit1 make cmake dotnet8

# Installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Avoid restart shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js (you may need to restart the terminal)
nvm install 22
node -v
nvm current
corepack enable pnpm
pnpm -v

# Add Apps With snap
sudo snap install discord
sudo snap install obs-studio 
sudo snap install vlc 
sudo snap install code --classic
sudo snap install intellij-idea-community --classic

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker 
sudo usermod -aG docker $USER

# ZSH
sudo apt install zsh

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
