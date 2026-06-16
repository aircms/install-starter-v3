#!/bin/sh

rootDirectory=$(realpath $(dirname $0));

step "Deploying: API to /var/www/$folderName/api";
mkdir -p "/var/www/$folderName/api";
cd "/var/www/$folderName/api";

git clone "git@github.com:aircms/starter-v3.git" .;

export COMPOSER_ALLOW_SUPERUSER=1;
composer update;
composer run-script assets;

step "Deploying: FS to /var/www/$folderName/fs";
mkdir -p "/var/www/$folderName/fs";
cd "/var/www/$folderName/api";

git clone "git@github.com:aircms/fs.git" .;

export COMPOSER_ALLOW_SUPERUSER=1;
composer update;
composer run-script assets;
composer run-script storage;

cd $rootDirectory;


