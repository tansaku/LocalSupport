#!/bin/bash
# This script is designed for Ubuntu 12.04
# Once you have forked and cloned this repo you can run this script to set it up
# cd LocalSupport and
# run with . <filename>.sh

# Get password to be used with sudo commands
echo -n "Enter password to be used for sudo commands:"
read -s password

# Function to issue sudo command with password
function sudo-pw {
    echo $password | sudo -S $@
}

# Update RVM and Ruby
echo Y | rvm get stable
rvm reload
echo Y | rvm upgrade 1.9.3

# Install Qt webkit headers
sudo-pw apt-get install -y libqtwebkit-dev

# Install postgreSQL
sudo-pw apt-get install -y libpq-dev
sudo-pw apt-get install -y postgresql

# Install X virtual frame buffer
sudo-pw apt-get install -y xvfb

# Remove un-needed packages
sudo-pw apt-get -y autoremove

# git checkout develop
git checkout develop

# Run bundle install to get the gems
bundle install
selenium install

# Run the following to get the database set up and import seed data
bundle exec rake db:create
bundle exec rake db:migrate
echo "Please wait, seeding database, this could take a while ..."
bundle exec rake db:categories
bundle exec rake db:seed
bundle exec rake db:cat_org_import
bundle exec rake db:pages
bundle exec rake db:test:prepare

echo "**** NOTICE ****"
echo "SETUP COMPLETE"
echo "You can now run rails s to start a local server. See db/seeds.rb for user info"
echo "You can run the following commands to test your setup. All tests should pass"
echo "bundle exec rake spec"
echo "bundle exec rake cucumber"
