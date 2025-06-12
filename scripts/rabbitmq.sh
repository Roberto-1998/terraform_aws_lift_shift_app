#!/bin/bash
set -e

# Importar claves GPG
sudo rpm --import https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc
sudo rpm --import https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key
sudo rpm --import https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key

# Descargar repositorio de RabbitMQ
sudo curl -fsSL -o /etc/yum.repos.d/rabbitmq.repo https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/awsliftandshift/al2023rmq.repo

# Actualizar e instalar dependencias
sudo dnf update -y
sudo dnf install -y socat logrotate erlang rabbitmq-server

# Habilitar e iniciar el servicio
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# Esperar a que el servicio esté disponible
sleep 5
until sudo rabbitmqctl status &>/dev/null; do
    echo "⏳ Esperando que RabbitMQ esté disponible..."
    sleep 3
done

# Crear archivo de configuración
sudo mkdir -p /etc/rabbitmq
echo '[{rabbit, [{loopback_users, []}]}].' | sudo tee /etc/rabbitmq/rabbitmq.config > /dev/null

# Crear usuario "test" solo si no existe
if ! sudo rabbitmqctl list_users | grep -q '^test\s'; then
    sudo rabbitmqctl add_user test test
    sudo rabbitmqctl set_user_tags test administrator
    sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
fi

# Reiniciar el servicio
sudo systemctl restart rabbitmq-server
