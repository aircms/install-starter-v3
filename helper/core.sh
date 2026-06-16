# General
step "Installing General";
sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf;
sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf;
apt update -y && apt upgrade -y;

# Apache
step "Installing Apache";
apt install apache2 -y;
rm -rf /var/www/html;
a2enmod headers expires rewrite ssl proxy proxy_http;
systemctl enable --now apache2;
systemctl reload-or-restart apache2;

# Php
step "Installing PHP";
apt install software-properties-common -y;
add-apt-repository ppa:ondrej/php -y;
apt install php8.5 libapache2-mod-php8.5 php8.5-cli php8.5-common php8.5-mongodb php8.5-imap php8.5-mbstring php8.5-gd php8.5-curl php8.5-xml php8.5-imagick -y;

# Install additional software
apt install unzip composer imagemagick ffmpeg -y;

# Mongo
step "Installing Mongo";
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -;
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor --yes;
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list;
apt update -y;
apt install mongodb-org -y;
systemctl restart mongod.service;
systemctl enable mongod.service;

# Supervisor
step "Installing Supervisor";
apt install supervisor -y;
