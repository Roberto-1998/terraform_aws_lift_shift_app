#!/bin/bash
set -e  # Hace que el script falle si alguna línea falla

# Instalar memcached
sudo dnf install -y memcached

# Habilitar e iniciar el servicio
sudo systemctl enable memcached
sudo systemctl start memcached

# Validar que el servicio esté activo sin bloquear Terraform
sudo systemctl is-active --quiet memcached

# Opcional: Permitir conexiones remotas (Amazon Linux 2023 usa /etc/memcached.conf)
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached || true

# Reiniciar para aplicar cambios
sudo systemctl restart memcached
