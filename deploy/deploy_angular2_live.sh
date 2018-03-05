#!/usr/bin/env bash

REPO='ssh://git@github.com/username/my-repository.git';
RELEASE_DIR='/var/www/mywebsite.com/releases';
APP_DIR='/var/www/mywebsite.com/web';
RELEASE="release_`date +%Y%m%d%H%M%s`";

# Fetch Latest Code
[ -d $RELEASE_DIR ] || mkdir $RELEASE_DIR;
cd $RELEASE_DIR;
git clone -b master $REPO $RELEASE_DIR/$RELEASE;

cd $RELEASE_DIR/$RELEASE;
sudo npm install;
sudo bower install --allow-root;

# Symlinks
ln -nfs $RELEASE_DIR/$RELEASE $APP_DIR;
chgrp -h www-data $APP_DIR;

## Env File
cd $RELEASE_DIR/$RELEASE;
ln -nfs ../../.env .env;
chgrp -h www-data .env;

## Logs
rm -r $RELEASE_DIR/$RELEASE/storage/logs;
cd $RELEASE_DIR/$RELEASE/storage;
ln -nfs ../../../logs logs;
chgrp -h www-data logs;

## Update Currente Site
ln -nfs $RELEASE_DIR/$RELEASE $APP_DIR/release;
chgrp -h www-data $APP_DIR;

sudo cd $APP_DIR/release;
sudo forever stop myapplication;
sudo forever start -a --uid "myapplication" -c "python -m SimpleHTTPServer" ./;
