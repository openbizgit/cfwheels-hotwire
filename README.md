cfwheels-hotwire
================

A baseplate for Coldfusion on Wheels applications

SERVER SETUP (In Progress.. Ruby gems not installing)

``
sudo apt-get install curl -y && sudo curl -o /tmp/setup.sh https://raw.githubusercontent.com/chapmandu/cfwheels-hotwire/master/setup/setup.sh && sudo sh /tmp/setup.sh && \curl -sSL https://get.rvm.io | bash -s stable && source /home/$USER/.rvm/scripts/rvm && rvm requirements && rvm install 2.1.2 && rvm use 2.1.2 --default && gem install capybara capybara-webkit rspec selenium-webdriver pry
``

TOOO
----
- Implement AssetBundler plugin
- Review tests scaffold templates to resemble rspec tests
- Flash message are not positioned properly.. also in signin controller

CONFIGURATION
----
- Change securityString in constants().. events/functions/misc.cfm
- Change the reload password in config/settings.cfm and config/deploy.rb (@reload_params)
- AWS Secret Keys in app.cfm and config/settings.cfm (x2)

