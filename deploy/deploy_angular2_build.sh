#!/usr/bin/env bash

REPO='ssh://git@github.com/username/my-repository.git';
RELEASE_DIR='/var/www/mywebsite.com/releases';
APP_DIR='/var/www/mywebsite.com/web';
RELEASE="release_`date +%Y%m%d%H%M%s`";

# Fetch the latest code
[ -d $RELEASE_DIR ] || mkdir $RELEASE_DIR;
cd $RELEASE_DIR;
git clone -b master $REPO $RELEASE_DIR/$RELEASE;

# Install dependencies
cd $RELEASE_DIR/$RELEASE;
sudo npm install;
sudo bower install --allow-root;

# Logs
rm -r $RELEASE_DIR/$RELEASE/storage/logs;
cd $RELEASE_DIR/$RELEASE/storage;
ln -nfs ../../../logs logs;
chgrp -h www-data logs;

#Build the application
ng build --prod --output-path /var/www/mywebsite.com/dist;