#!/bin/bash

export APP_USER_HOME=/home/mob_app_usr/
export BACKEND_PATH="${APP_USER_HOME}Mobalysis/backend/"

sudo echo 'export DBNAME=mobalytics' >> "${APP_USER_HOME}.bashrc"
sudo echo 'export DBUSER=mob_db_user' >> "${APP_USER_HOME}.bashrc"
sudo echo 'export DBPASS=mob_db_pass' >> "${APP_USER_HOME}.bashrc"
sudo echo 'export DBHOST=localhost' >> "${APP_USER_HOME}.bashrc"
sudo echo 'export DBPORT=5432' >> "${APP_USER_HOME}.bashrc"

# Clone Mobalysis repository to home directory
cd $APP_USER_HOME 
git clone https://github.com/theophilusbittok1/Mobalysis.git

#Install application packages for backend in virtual environment
sudo apt install -y python3-pip
sudo apt install -y python3-venv
sudo python3 -m venv env
source env/bin/activate
sudo pip install -r "${BACKEND_PATH}requirements.txt"

# Make and install database migrations
python3 "${BACKEND_PATH}manage.py make migrations"
python3 "${BACKEND_PATH}manage.py migrate"
