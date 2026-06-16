step()
{
  local _message=$1;
  local _sleep=3;

  echo "#####################################################################";
  echo "$_message";
  echo "#####################################################################";
  echo "Will continue in $_sleep seconds";
  echo "#####################################################################";
  sleep $_sleep;
}


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
apt install php8.4 libapache2-mod-php8.4 php8.4-cli php8.4-common php8.4-mongodb php8.4-imap php8.4-mbstring php8.4-gd php8.4-curl php8.4-xml php8.4-imagick -y;

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


# Environment
step "Setup environment";

echo "AIR_FS_URL=\"https://fs.domain.com/\"" >> /etc/environment;
echo "AIR_FS_KEY=\"fsKey\"" >> /etc/environment;

echo "AIR_DB_HOST=\"localhost\"" >> /etc/environment;
echo "AIR_DB_PORT=\"27017\"" >> /etc/environment;
echo "AIR_DB_DB=\"dbName\"" >> /etc/environment;
echo "AIR_DB_USER=\"\"" >> /etc/environment;
echo "AIR_DB_PASS=\"\"" >> /etc/environment;

echo "AIR_ADMIN_AUTH_ROOT_LOGIN=\"root\"" >> /etc/environment;
echo "AIR_ADMIN_AUTH_ROOT_PASSWORD=\"23wesdxc\"" >> /etc/environment;
echo "AIR_ADMIN_TINY_KEY=\"tinyKey\"" >> /etc/environment;

mkdir /etc/systemd/system/apache2.service.d;
echo "[Service]" >> /etc/systemd/system/apache2.service.d/environment.conf;
echo "EnvironmentFile=/etc/environment" >> /etc/systemd/system/apache2.service.d/environment.conf;

content=$(sed '/\[Service\]/a EnvironmentFile=/etc/environment' /lib/systemd/system/supervisor.service);
printf '%s\n' "$content" > /lib/systemd/system/supervisor.service;

sudo systemctl daemon-reload;
sudo service supervisor stop;
sudo service apache2 restart;
