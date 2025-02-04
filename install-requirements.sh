#!/bin/bash

# Fungsi untuk memeriksa apakah sebuah perintah tersedia
command_exists() {
    command -v "$1" &> /dev/null
}

# Fungsi untuk menginstal paket menggunakan apt
install_package() {
    echo "Installing $1..."
    sudo apt update
    sudo apt install -y "$1"
}

# 1. Memeriksa dan menginstal Git
if ! command_exists git; then
    install_package git
else
    echo "Git is already installed."
fi

# 2. Memeriksa dan menginstal Apache
if ! command_exists apache2; then
    install_package apache2
    # Aktifkan modul rewrite dan ssl
    sudo a2enmod rewrite
    sudo a2enmod ssl
    sudo systemctl restart apache2
    echo "Apache installed and configured."
else
    echo "Apache is already installed."
fi

# 3. Memeriksa dan menginstal PHP
if ! command_exists php; then
    install_package php
    # Instal ekstensi PHP yang diperlukan oleh Laravel
    install_package php-cli php-fpm php-mysql php-zip php-json php-mbstring php-xml
    echo "PHP and required extensions installed."
else
    echo "PHP is already installed."
fi

# 4. Memeriksa dan menginstal Composer
if ! command_exists composer; then
    echo "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    echo "Composer installed."
else
    echo "Composer is already installed."
fi

# 5. Memeriksa dan menginstal mkcert
if ! command_exists mkcert; then
    echo "Installing mkcert..."
    sudo apt install -y libnss3-tools
    curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
    chmod +x mkcert-v*-linux-amd64
    sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert
    echo "mkcert installed."
else
    echo "mkcert is already installed."
fi

# 6. Memeriksa dan menginstal Node.js (Opsional)
if ! command_exists node; then
    echo "Installing Node.js and NPM..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
    echo "Node.js and NPM installed."
else
    echo "Node.js is already installed."
fi

# 7. Memeriksa dan menginstal MySQL/MariaDB (Opsional)
if ! command_exists mysql; then
    echo "Installing MySQL Server..."
    sudo apt install -y mysql-server
    echo "MySQL Server installed."
else
    echo "MySQL Server is already installed."
fi

echo "All requirements are now installed!"