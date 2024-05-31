# Update
sudo apt update

# Paquetes Herramientas
echo "Installando Herramientas Generales"
sudo apt install aptitude vim emacs nano strace ssh curl htop tree wget terminator xclip bless neofetch net-tools

# Lenguajes de Programacion
echo "Installando Lenguajes y Herramientas de Programacion"
sudo apt install build-essential autotools-dev gcc gdb g++ python3 python3-pip openjdk-21-jdk openjdk-21-jre libcunit1-dev libcunit1 make cmake bless

# DEV Utils
echo "Installando Utilidades de Programacion"
sudo apt install valgrind meld 
