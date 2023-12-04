#!/bin/bash
#Script MyApp

# Lista de paquetes a instalar
paquetes=("javascript-common" "git" "nginx" "nodejs")
set -e

# Establecer el frontend de debconf a noninteractive
export DEBIAN_FRONTEND=noninteractive
sudo apt-get purge javascript-common &&

# Actualizar la lista de paquetes
sudo apt-get update &&

# Descargar e instalar el script de configuración de NodeSource
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - &&

# Instalar los paquetes
sudo apt-get install -y "${paquetes[@]}"

# Esperar hasta que todos los paquetes esten instalados
for paquete in "${paquetes[@]}"; do
    while ! dpkg -s "$paquete" &> /dev/null; do
        echo "Esperando a que el paquete $paquete se instale..."
        sleep 1
    done
done

#Install PM2 y NPM
sudo npm install npm@latest -g
sudo npm install pm2@latest -g

#Descargar App
cd /var/www/
sudo git clone https://github.com/CHimaLeo/MyApp.git
# Esperar a que el proceso de clonación termine
wait

#Inicia la App
cd MyApp
sudo npm install
sudo pm2 start index.js
sudo pm2 startup systemd

#Configurar Nginx
sudo mv /home/ubuntu/myapp /etc/nginx/sites-available/
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/myapp
sudo service nginx restart

# Restaurar el valor predeterminado del frontend de debconf al final del script (opcional)
unset DEBIAN_FRONTEND
