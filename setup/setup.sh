#!/bin/bash
# =========================================
# boostrap this box for use with capistrano
# =========================================
#
# - This script will produce a working version of Tomcat7, Railo with Nginx web server. 
# - The web root will be setup for deployment via Capistrano using the "deploy" user
# - CFWheels rewrite rules have been enabled
# - SSH keys for accepting connections from Jenkins and for accessing Valet Service Github repos have been created
#
# NOTE: The Railo administrator is not secured, and there are no datasources set.
#
# MANUAL STEPS REQUIRED
# =======================================================================
#
# create the user's ssh folder and keys for deploying with capistrano.. see:
# http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/
#
# add this to /etc/sudoers file by running "sudo visudo".. NOTE!! Make sure the "%deploy.." line is uncommented!!
#
# Allow deploy user to restart services
# %deploy ALL=NOPASSWD:/etc/init.d/tomcat7, /etc/init.d/nginx, /bin/fuser, /bin/rm, /bin/sh

RAILO_VERSION="4.2.1.000"
WEB_ROOT="/var/www/app"

# install packages
sudo apt-get install curl -y
sudo apt-get install nginx -y
sudo apt-get install tomcat7 -y
sudo apt-get install curl -y
sudo apt-get install git -y

# install rvm, ruby and gems for rspec/capistrano
curl -sSL https://get.rvm.io | bash -s stable
rvm requirements
rvm install 2.1.2
rvm use 2.1.2 --default
ruby -v

gem install capybara
gem install capybara-webkit
gem install rspec
gem install selenium-webdriver
gem install pry

# get the hotwire tarball from github ready for extraction to the webroot
sudo curl -L -o /tmp/hotwire.tar.gz https://api.github.com/repos/chapmandu/cfwheels-hotwire/tarball
cd /tmp/
sudo tar -zxvf /tmp/cfwheels-hotwire.tar.gz
# rename the folder to something predictable
sudo rm -r /tmp/cfwheels-hotwire
sudo mv chapmandu-cfwheels-hotwire-*/ hotwire/

# TODO: maybe change this to call an 'update-railo.sh' script
# download railo & unpack jars
wget -O /tmp/railo-$RAILO_VERSION-jars.tar.gz http://www.getrailo.org/down.cfm?item=/railo/remote/download/$RAILO_VERSION/custom/all/railo-$RAILO_VERSION-jars.tar.gz
cd /tmp
tar -zxvf /tmp/railo-$RAILO_VERSION-jars.tar.gz 

# change owner of railo classes dir
sudo chown -R tomcat7 /usr/share/tomcat7/lib

# add the deploy user (make him a sudoer)
sudo adduser --disabled-password --gecos "" deploy
# sudo adduser deploy sudo
sudo passwd -l deploy

# add a common group for tomcat7 and deploy users
sudo groupadd railoers
sudo usermod -a -G railoers tomcat7
sudo usermod -a -G railoers deploy

# create WEB_ROOT
sudo mkdir -p ${WEB_ROOT}/releases ${WEB_ROOT}/current ${WEB_ROOT}/shared/WEB-INF
# permanently symlink the WEB-INF directory
sudo ln -s ${WEB_ROOT}/shared/WEB-INF/ ${WEB_ROOT}/current/
# can't write directly to /etc/init.d ???
sudo echo -e 'ln -s ${WEB_ROOT}/shared/WEB-INF/ ${WEB_ROOT}/current/' > /tmp/railo-webinf-symlink
sudo mv /tmp/railo-webinf-symlink /etc/init.d/railo-webinf-symlink
# TODO: do i need to change the permissions so this can be run at boot?

# extract the hotwire code to the web root
sudo cp -rf /tmp/hotwire/* ${WEB_ROOT}/current/
# delete stuff that doesn't belong in the web root
sudo rm -r ${WEB_ROOT}/current/setup

# give the railoers full access to the WEB_ROOT and everything under it
# umask 002
sudo chgrp -R railoers ${WEB_ROOT}
# make all future files written belong to this group
sudo chmod -R g+rwxs ${WEB_ROOT}

# move files into their correct location
# tomcat
sudo cp -rf /tmp/railo-$RAILO_VERSION-jars/* /usr/share/tomcat7/lib/
sudo cp -rf /tmp/hotwire/setup/tomcat/web.xml /var/lib/tomcat7/conf/web.xml
sudo cp -rf /tmp/hotwire/setup/tomcat/server.xml /var/lib/tomcat7/conf/server.xml
# nginx
sudo cp -rf /tmp/hotwire/setup/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp -rf /tmp/hotwire/setup/nginx/proxy_params /etc/nginx/proxy_params
sudo cp -rf /tmp/hotwire/setup/nginx/cfwheels_rewrite_rules /etc/nginx/cfwheels_rewrite_rules
sudo cp -rf /tmp/hotwire/setup/nginx/sites-enabled/default /etc/nginx/sites-enabled/default

# change nginx permissions
sudo chmod 755 /etc/nginx/nginx.conf
sudo chown root /etc/nginx/nginx.conf
sudo chgrp root /etc/nginx/nginx.conf

# write /usr/share/tomcat7/bin/sentenv.sh file
sudo cp -rf /tmp/hotwire/setup/tomcat/setenv-micro.sh /usr/share/tomcat7/bin/sentenv.sh
# give it the same permissions as the other .sh files
sudo chmod u+rwx /usr/share/tomcat7/bin/sentenv.sh
sudo chmod g+rx /usr/share/tomcat7/bin/sentenv.sh
sudo chmod o+rx /usr/share/tomcat7/bin/sentenv.sh
sudo chmod o-w /usr/share/tomcat7/bin/sentenv.sh

# create swap
echo "Creating swap ..."
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo mkswap /swapfile
sudo swapon /swapfile
sudo sed -i.backup '1 a\/swapfile swap swap defaults 0 0' /etc/fstab # adds a new line to the file

# create the user's ssh folder and keys
# sudo mkdir /home/deploy/.ssh
# sudo cp -rf /tmp/hotwire/setup/jenkins/capistrano/deploy/* /home/deploy/.ssh/
# sudo chown deploy /home/deploy/.ssh
# sudo chown deploy /home/deploy/.ssh/*
# sudo chmod 700 /home/deploy/.ssh
# sudo chmod 600 /home/deploy/.ssh/authorized_keys
# sudo chmod 600 /home/deploy/.ssh/id_rsa
# sudo chmod 600 /home/deploy/.ssh/known_hosts

# restart services
sudo fuser -k 80/tcp # kill any other process using port 80
sudo /etc/init.d/tomcat7 restart
sudo /etc/init.d/nginx restart

echo "*** ----------------------------------------- ***"
echo "***         Now do the manual steps!          ***"
echo "*** ----------------------------------------- ***"