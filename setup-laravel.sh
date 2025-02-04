#!/bin/bash

# Pastikan script dieksekusi dengan parameter nama project
if [ -z "$1" ]; then
    echo "Usage: setup-laravel <project-name>"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="/home/$USER/projects/$PROJECT_NAME"
VHOST_FILE="/etc/apache2/sites-available/$PROJECT_NAME.conf"
DOMAIN="$PROJECT_NAME.test"
CERT_DIR="$HOME/.local/share/mkcert"

# Step 1: Cek apakah Composer sudah terinstal
if ! command -v composer &> /dev/null; then
    echo "Composer is not installed. Please install it first."
    exit 1
fi

# Step 2: Membuat direktori project jika belum ada
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR"
    echo "Directory $PROJECT_DIR created."
else
    echo "Directory $PROJECT_DIR already exists."
fi

# Step 3: Membuat project Laravel
echo "Creating Laravel project..."
composer create-project --prefer-dist laravel/laravel "$PROJECT_DIR"

# Step 4: Menyiapkan Virtual Host di Apache
echo "Setting up Virtual Host..."
sudo bash -c "cat > $VHOST_FILE" <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    DocumentRoot "$PROJECT_DIR/public"
    
    <Directory "$PROJECT_DIR/public">
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$PROJECT_NAME-error.log
    CustomLog \${APACHE_LOG_DIR}/$PROJECT_NAME-access.log combined
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    DocumentRoot "$PROJECT_DIR/public"

    <Directory "$PROJECT_DIR/public">
        AllowOverride All
        Require all granted
    </Directory>

    SSLEngine on
    SSLCertificateFile $CERT_DIR/$DOMAIN.pem
    SSLCertificateKeyFile $CERT_DIR/$DOMAIN-key.pem

    ErrorLog \${APACHE_LOG_DIR}/$PROJECT_NAME-ssl-error.log
    CustomLog \${APACHE_LOG_DIR}/$PROJECT_NAME-ssl-access.log combined
</VirtualHost>
EOF

# Step 5: Setup SSL menggunakan mkcert
if ! command -v mkcert &> /dev/null; then
    echo "mkcert is not installed. Please install it first."
    exit 1
fi

echo "Setting up SSL with mkcert..."
mkcert -install
mkdir -p "$CERT_DIR"
mkcert -cert-file "$CERT_DIR/$DOMAIN.pem" -key-file "$CERT_DIR/$DOMAIN-key.pem" "$DOMAIN"

# Step 6: Mengaktifkan Virtual Host dan reload Apache
sudo a2ensite "$PROJECT_NAME"
sudo systemctl reload apache2

# Step 7: Menambahkan domain ke /etc/hosts
if ! grep -q "$DOMAIN" /etc/hosts; then
    echo "127.0.0.1 $DOMAIN" | sudo tee -a /etc/hosts > /dev/null
    echo "Domain $DOMAIN added to /etc/hosts."
else
    echo "Domain $DOMAIN already exists in /etc/hosts."
fi

echo "Setup complete! Visit https://$DOMAIN in your browser."
