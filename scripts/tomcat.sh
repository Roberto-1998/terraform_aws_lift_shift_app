#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Eliminar needrestart para evitar prompts
sudo apt remove -y needrestart

# Actualización de paquetes
sudo apt update
sudo apt -y upgrade

# Instalación de Java y Tomcat
sudo apt -y install openjdk-17-jdk
sudo apt -y install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git
