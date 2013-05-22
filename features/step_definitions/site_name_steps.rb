require 'webmock/cucumber'
require 'uri-handler'

Given /^the site name is "(.+)"$/ do |name|
  SiteName.create! :site_name => name
end

When(/^the site name should be "([^"]*)"$/) do |title|
  find('title').native.text.should have_content title
end

When(/^the site name should not be "([^"]*)"$/) do |title|
  find('title').native.text.should_not have_content title
end