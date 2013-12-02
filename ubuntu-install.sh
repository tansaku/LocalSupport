#!/bin/bash
# This script is designed for Ubuntu 12.04
# Once you have forked and cloned this repo you can run this script to set it up
# cd LocalSupport and
# run with . <filename>.sh

# Get password to be used with sudo commands
# Script still requires password entry during rvm and heroku installs
echo -n "Enter password to be used for sudo commands:"
read -s password

# Function to issue sudo command with password
function sudo-pw {
    echo $password | sudo -S $@
}

#5. Install Qt webkit headers
sudo-pw apt-get install -y libqtwebkit-dev

#6. Install postgreSQL
sudo-pw apt-get install -y libpq-dev
sudo-pw apt-get install -y postgresql

#7. Install X virtual frame buffer
sudo-pw apt-get install -y xvfb

#8. git pull origin develop
git pull origin develop

#9. git checkout develop
git checkout develop

#10. Run bundle install to get the gems
bundle install

#11. Run the following to get the database set up and import seed data
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:categories
bundle exec rake db:seed
bundle exec rake db:cat_org_import
bundle exec rake db:pages

echo "You can now run rails s to start a local server. See db/seeds.rb for user info"
echo "You can run the following commands to test your setup"
echo "rake db:test:prepare"
echo "bundle exec rake spec"
echo "bundle exec rake cucumber"