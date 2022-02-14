#!/bin/bash


export DBNAME="mobalytics" 
export DBUSER="mob_db_user" 
export DBPASS="mob_db_pass" 
export DBHOST="localhost" 
export DBPORT="5432"

#Install application packages for backend in virtual environment
sudo apt-get install python3-pip
sudo pip3 install virtualenv
virtualenv env

# Clone Mobalysis repository to home directory
cd /home/mob_app_usr 
git clone https://github.com/theophilusbittok1/Mobalysis.git
