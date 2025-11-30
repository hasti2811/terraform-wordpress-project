#!/bin/bash

# Update system
sudo apt update -y

# Install prerequisites
sudo apt install -y ca-certificates curl gnupg

# Create keyring dir
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repo (Terraform-safe — NO $()!!)
/bin/bash -c 'cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: focal
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF'

# Install Docker + Compose
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

# Create Docker project directories
mkdir -p /home/ubuntu/wordpress /home/ubuntu/apache-app

# WordPress Dockerfile
cat <<'EOL' > /home/ubuntu/wordpress/Dockerfile
FROM wordpress:latest

WORKDIR /var/www/html

RUN rm -rf *

COPY . /var/www/html/
EOL

# Apache/PHP Dockerfile
cat <<'EOL' > /home/ubuntu/apache-app/Dockerfile
FROM php:apache

RUN a2enmod rewrite
RUN docker-php-ext-install mysqli pdo pdo_mysql

WORKDIR /var/www/html
EOL

# Docker Compose file
cat <<EOL > /home/ubuntu/compose.yaml
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: ${rds_endpoint}
      WORDPRESS_DB_USER: ${db_username}
      WORDPRESS_DB_PASSWORD: ${db_password}
      WORDPRESS_DB_NAME: ${db_name}
    volumes:
      - wordpress_data:/var/www/html

volumes:
  wordpress_data:
EOL

# Build images (even though WP uses official image)
sudo docker build -t my-wordpress-image -f /home/ubuntu/wordpress/Dockerfile /home/ubuntu/wordpress
sudo docker build -t my-apache-app-image -f /home/ubuntu/apache-app/Dockerfile /home/ubuntu/apache-app

# Start services
sudo docker compose -f /home/ubuntu/compose.yaml up -d
