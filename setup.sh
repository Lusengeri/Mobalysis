#!/usr/bin/env bash

# Install all dependencies
sudo apt update
sudo apt install python3-dev gcc python3-distutils python3-pip python3-venv postgresql nginx -y

# Set up postgres database
sudo -u postgres psql -c "create user mob_db_user with encrypted password 'mobdbpass'"
sudo -u postgres psql -c "create database mobalysis"
sudo -u postgres psql -c "grant all privileges on database mobalysis to mob_db_user"

#Set up the mob_app_user user
sudo useradd -m mob_app_user
sudo chsh -s /sbin/nologin mob_app_user
sudo -u mob_app_user sh -c 'cd /home/mob_app_user/ && git clone https://github.com/theophilusbittok1/Mobalysis'

#set up the application environment
sudo  bash -c 'echo "export DBUSER=mob_db_user" >> /home/mob_app_user/.bashrc'
sudo  bash -c 'echo "export DBNAME=mobalysis" >> /home/mob_app_user/.bashrc'
sudo  bash -c 'echo "export DBHOST=127.0.0.1" >> /home/mob_app_user/.bashrc'
sudo  bash -c 'echo "export DBPASS=mobdbpass" >> /home/mob_app_user/.bashrc'
sudo  bash -c 'echo "export DBPORT=5432" >> /home/mob_app_user/.bashrc'

# Setup the python environment and dependencies
sudo -u mob_app_user sh -c 'cd /home/mob_app_user/ && /usr/bin/python3 -m venv .env'
sudo -u mob_app_user bash -c 'cd /home/mob_app_user/ && source /home/mob_app_user/.env/bin/activate && pip3 install wheel uwsgi django && pip3 install -r /home/mob_app_user/Mobalysis/backend/requirements.txt && python /home/mob_app_user/Mobalysis/backend/manage.py migrate'

# Get IP address
MY_IP=`curl -s https://icanhazip.com`

# Change ALLOWED_HOSTS[] in settings.py to ALLOWED_HOSTS = ['<my_ip_address>']
sudo sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \['${MY_IP}'\]/" /home/mob_app_user/Mobalysis/backend/backend/settings.py

# Set-up nginx site configuration file  
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/default
sudo cp /home/mob_app_user/Mobalysis/mobalysis.conf /etc/nginx/sites-available/mobalysis.conf
sudo ln -s /etc/nginx/sites-available/mobalysis.conf /etc/nginx/sites-enabled/mobalysis.conf 

sudo service nginx restart

sudo mkdir -p /var/log/uwsgi/
sudo chown mob_app_user:www-data /var/log/uwsgi/

sudo mkdir -p /run/uwsgi/
sudo chown mob_app_user:www-data /run/uwsgi/

sudo -u mob_app_user bash -c 'cd /home/mob_app_user/Mobalysis/backend/'
sudo -u mob_app_user bash -c 'uwsgi --ini /home/mob_app_user/Mobalysis/backend/uwsgi.ini'

sudo chown mob_app_user:www-data /home/mob_app_user/Mobalysis/backend/mobalysis.sock
# sudo mkdir -p /run/uwsgi/ && chown mob_app_user:www-data /run/uwsgi
