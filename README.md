# Setup Laravel Script

This script automates the process of setting up a new Laravel project by:

- Creating a project directory at `/home/$USER/projects/<project-name>`
- Installing a new Laravel project using Composer
- Configuring Apache Virtual Hosts for both HTTP and HTTPS
- Setting up local SSL certificates using mkcert
- Adding the domain to `/etc/hosts` for local access

## Key Features

- **Automated Project Creation:** Creates the project directory and installs Laravel using Composer.
- **Apache Virtual Host Configuration:** Automatically generates and enables the Apache configuration for the domain `<project-name>.test`.
- **Local SSL Setup:** Uses mkcert to generate SSL certificates and configures HTTPS support.
- **Hosts File Update:** Adds the domain entry to `/etc/hosts` if it does not already exist.

## Prerequisites

Ensure you have the following installed and properly configured:

- **Composer:** Required to create and manage the Laravel project.
- **mkcert:** For generating local SSL certificates.
- **Apache2:** The web server to host your project.
- **Bash:** The script is written in Bash.
- **Sudo privileges:** Necessary for modifying Apache configuration and the `/etc/hosts` file.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/doublegunz/setup-laravel.git
   cd setup-laravel
   ```

2. **Make the script executable:**

   ```bash
   chmod +x setup-laravel.sh
   ```

## Usage

Run the script by providing the project name as an argument:

```bash
./setup-laravel.sh project_name
```

For example:

```bash
./setup-laravel.sh mylaravel
```

The script will perform the following steps:

1. **Check for Composer:** Verifies that Composer is installed.
2. **Create the Project Directory:** Creates `/home/$USER/projects/project_name` if it does not exist.
3. **Install Laravel:** Uses Composer to create a new Laravel project.
4. **Configure Apache Virtual Host:** Generates configuration files for both port 80 and 443 for the domain `project_name.test`.
5. **Enable the Virtual Host:** Activates the new Virtual Host and reloads Apache.
6. **Set Up SSL:** Uses mkcert to install and generate SSL certificates stored in `~/.local/share/mkcert`.
7. **Update /etc/hosts:** Adds an entry for `project_name.test` to the hosts file if it's not already present.

After the setup is complete, you can access your project by navigating to `https://project_name.test` in your browser.

## Troubleshooting

- **Composer Not Found:** Ensure Composer is installed and available in your PATH.
- **mkcert Not Found:** Install mkcert as per its official documentation.
- **Sudo Privileges:** Some steps require sudo access. Ensure you have the necessary permissions.
- **Virtual Host Issues:** Check the configuration file in `/etc/apache2/sites-available` and verify that it has been enabled with `a2ensite`.

## MySQL Setup (Optional)

By default, Laravel projects created by this script use **SQLite** for the database. If you prefer to use **MySQL**, follow these steps:

### 1. Access MySQL

After running `install-requirements.sh`, MySQL Server is installed but has no password set for the root user. MySQL 8.x uses `auth_socket` authentication by default, which means you need `sudo` to access:

```bash
sudo mysql
```

### 2. Create Database and User

Once inside the MySQL prompt, create a database and user for your Laravel project:

```sql
CREATE DATABASE laravel_db;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'your_password_here';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Replace `laravel_db`, `laravel_user`, and `your_password_here` with your preferred values.

### 3. Update Laravel .env File

Edit the `.env` file in your Laravel project directory (e.g., `/home/$USER/projects/project_name/.env`):

```bash
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=your_password_here
```

### 4. Run Laravel Migrations

```bash
cd /home/$USER/projects/project_name
php artisan migrate
```

### Optional: Secure MySQL Installation

For production or more secure environments, run:

```bash
sudo mysql_secure_installation
```

This will guide you through setting a root password, removing anonymous users, and other security improvements.

## Additional Notes

- You can modify the project directory, domain, and certificate paths by editing the variables in the script.
- Ensure that Apache and mkcert are properly configured before running the script.
- By default, projects use SQLite. Follow the MySQL Setup section above if you need MySQL instead.

## License

This repository is licensed under the [GPL-3.0 license](LICENSE).