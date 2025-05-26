#!/bin/bash

# Autor: Jaime Galvez Martinez
# Descripción: Instalador automático del cliente DUC de No-IP y su configuración como servicio systemd.

set -e

echo "=== ACTUALIZANDO EL SISTEMA ==="
sudo apt update && sudo apt upgrade -y

echo "=== INSTALANDO DEPENDENCIAS NECESARIAS ==="
sudo apt install -y build-essential libssl-dev

echo "=== DESCARGANDO E INSTALANDO DUC DE NO-IP ==="
cd /usr/local/src
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
sudo tar xzf noip-duc-linux.tar.gz
cd noip-2.1.9-1
sudo make
sudo make install

echo "=== CONFIGURANDO DUC ==="
sudo /usr/local/bin/noip2 -C

echo "=== CREANDO SERVICIO SYSTEMD ==="
sudo tee /etc/systemd/system/noip2.service > /dev/null <<EOL
[Unit]
Description=No-IP Dynamic DNS Update Client
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/noip2

[Install]
WantedBy=multi-user.target
EOL

echo "=== HABILITANDO Y INICIANDO EL SERVICIO ==="
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now noip2
sudo systemctl status noip2
