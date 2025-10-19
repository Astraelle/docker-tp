#!/bin/bash
# Nettoyage
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null
docker network rm tp3_net 2>/dev/null

# Création du réseau
docker network create tp3_net

# Container PHP-FPM
docker run -d --name script \
  --network tp3_net \
  -v $(pwd)/app:/app \
  php:8.2-fpm

# Container Nginx
docker run -d --name http \
  --network tp3_net \
  -p 8080:80 \
  -v $(pwd)/app:/app \
  -v $(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf \
  nginx:latest
