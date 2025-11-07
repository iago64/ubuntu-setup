#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Update ---
sudo apt update -y && sudo apt upgrade -y

# --- Herramientas básicas ---
sudo apt install -y \
    aptitude vim emacs nano strace ssh curl htop tree wget terminator \
    xclip neofetch net-tools valgrind meld blueman gnupg software-properties-common

# --- Lenguajes y compiladores ---
sudo apt install -y \
    build-essential autotools-dev gcc gdb g++ python3 python3-pip \
    libcunit1-dev libcunit1 make cmake dotnet8

# --- Adoptium Temurin JDK 21 ---
if ! command -v java >/dev/null 2>&1; then
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add -
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.adoptium.net/artifactory/deb \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") main" \
    | sudo tee /etc/apt/sources.list.d/adoptium.list > /dev/null
    sudo apt update -y
    sudo apt install -y temurin-21-jdk
fi

# --- NVM / Node.js 24 / PNPM ---
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
fi

source "$HOME/.nvm/nvm.sh"
nvm install 24
nvm alias default 24
corepack enable pnpm

# --- Aplicaciones Snap ---
sudo snap install discord
sudo snap install obs-studio
sudo snap install vlc
sudo snap install code --classic
sudo snap install intellij-idea-community --classic

# --- Docker ---
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings

if [[ ! -f /etc/apt/keyrings/docker.asc ]]; then
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"${UBUNTU_CODENAME:-$VERSION_CODENAME}\") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# --- ZSH + Oh My Zsh ---
sudo apt install -y zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
