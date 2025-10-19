#!/bin/bash
# Nettoyage
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null
docker network rm tp3_net 2>/dev/null

# Création du réseau
docker network create tp3_net

# Container base de données (DATA)
docker run -d --name data \
  --network tp3_net \
  -e MARIADB_DATABASE=testdb \
  -e MARIADB_USER=user \
  -e MARIADB_PASSWORD=pass \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -v $(pwd)/db:/docker-entrypoint-initdb.d \
  mariadb:latest

# Construction de l’image PHP avec mysqli
docker build -t php-mysqli .

# Container PHP-FPM (SCRIPT)
docker run -d --name script \
  --network tp3_net \
  -v $(pwd)/app:/app \
  php-mysqli

# Container Nginx (HTTP)
docker run -d --name http \
  --network tp3_net \
  -p 8080:80 \
  -v $(pwd)/app:/app \
  -v $(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf \
  nginx:latest