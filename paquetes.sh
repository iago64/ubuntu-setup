#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Update ---
sudo apt update -y && sudo apt upgrade -y

# --- Herramientas básicas ---
sudo apt install -y aptitude vim emacs nano strace ssh curl htop tree wget terminator xclip net-tools valgrind meld blueman gnupg

# --- Lenguajes y compiladores ---
sudo apt install -y build-essential autotools-dev gcc gdb g++ python3 python3-pip libcunit1-dev libcunit1 make cmake dotnet-sdk-10.0

# --- SDKMAN ---
if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java 21.0.10-amzn
    sdk install java 25.0.2-amzn
    sdk install quarkus
    sdk install gradle
fi

# --- NVM / Node.js / PNPM ---
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
fi

source "$HOME/.nvm/nvm.sh"
nvm install 24
nvm alias default 24
corepack enable pnpm

source "$HOME/.nvm/nvm.sh"
nvm install 24
nvm alias default 24
corepack enable pnpm

# --- Aplicaciones Snap ---
if command -v snap >/dev/null 2>&1; then
    sudo snap install discord
    sudo snap install obs-studio
    sudo snap install vlc
    sudo snap install code --classic
else
    echo "snap no esta instalado; se omiten las instalaciones con snap"
fi

# --- JetBrains Toolbox ---
TBA_LINK=$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
wget -qO- "${TBA_LINK:?}" | sudo tar xvzC /opt
/opt/jetbrains-toolbox-*/bin/jetbrains-toolbox

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

# --- Podman ---
sudo apt install -y podman podman-compose
systemctl --user enable --now podman.socket

# --- ZSH + Oh My Zsh ---
sudo apt install -y zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Integrar configuraciones de entorno en Zsh ---
ZSHRC="$HOME/.zshrc"

{
    echo ""
    echo "# --- Entorno de desarrollo personalizado ---"
    echo "# NVM / Node.js"
    echo 'export NVM_DIR="$HOME/.nvm"'
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
    echo ""
    echo "# PNPM"
    echo 'export PATH="$HOME/.local/share/pnpm:$PATH"'
    echo ""
    echo "# SDKMAN"
    echo 'export SDKMAN_DIR="$HOME/.sdkman"'
    echo '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"'
    echo ""
    echo "# Java"
    echo 'export JAVA_HOME="/usr/lib/jvm/temurin-21-jdk"'
    echo 'export PATH="$JAVA_HOME/bin:$PATH"'
    echo ""
} >> "$ZSHRC"