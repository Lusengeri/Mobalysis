#!/bin/bash

export DBNAME="mobalytics"
export DBUSER="mob_db_user"
export DBPASS="mob_db_pass"
export DBHOST="localhost" 
export DBPORT="5432"
BACKEND_PATH="/home/mob_app_usr/Mobalysis/backend/"

# Clone Mobalysis repository to home directory
cd /home/mob_app_usr
git clone https://github.com/theophilusbittok1/Mobalysis.git

#Install application packages for backend in virtual environment
sudo apt-get install python3-pip
sudo pip3 install virtualenv
sudo virtualenv env
sudo source env/bin/activate
sudo pip install -r "${BACKEND_PATH}requirements.txt"

# Make and install database migrations
python3 "${BACKEND_PATH}manage.py make migrations"
python3 "${BACKEND_PATH}manage.py migrate"
