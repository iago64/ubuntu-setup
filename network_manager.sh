#!/bin/bash

# Crear el archivo de configuración de Netplan para usar NetworkManager
sudo tee /etc/netplan/01-network-manager-all.yaml > /dev/null <<EOF
network:
  version: 2
  renderer: NetworkManager
EOF

# Aplicar configuración de red
sudo netplan apply

# Reiniciar NetworkManager
sudo systemctl restart NetworkManager

# Mostrar el estado de las interfaces
nmcli device
