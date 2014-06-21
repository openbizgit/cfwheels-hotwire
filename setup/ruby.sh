#!/bin/bash

# install rvm, ruby and gems for rspec/capistrano
# i'm having permission denies issues here... just install ruby with apt-get for now
\curl -sSL https://get.rvm.io | bash -s stable && source /home/$USER/.rvm/scripts/rvm && rvm requirements && rvm install 2.1.2 && rvm use 2.1.2 --default && gem install capybara capybara-webkit rspec selenium-webdriver pry