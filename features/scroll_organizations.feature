Feature: A member of public can choose the page with organizations to be displayed
  As a member of public
  So that I can be prevented from loading a large amount of data
  I want to be able to select a page with organizations
  Tracker story ID: 50078927

Scenario: Only first 10 organizations are displayed
  Given I am on the charity search page
  Then Only 10 organizations should be displayed

#Scenario: Another 10 organizations are displayed
#  Given I am on the charity search page
#  When I click to display 2nd page
#  Then Another 10 organizations should be displayed
