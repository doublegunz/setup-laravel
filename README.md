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
   git clone https://github.com/username/repository-name.git
   cd repository-name
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

## Additional Notes

- You can modify the project directory, domain, and certificate paths by editing the variables in the script.
- Ensure that Apache and mkcert are properly configured before running the script.

## License

This repository is licensed under the [MIT License](LICENSE).