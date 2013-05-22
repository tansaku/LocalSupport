Feature: Admin Changing Site Name
  As a site administrator
  So that I can change my site name
  I want to have a page allowing me to change the site name

Background: site name has been added to database
  Given the site name is "Local Support"

Scenario: Change Site Name
  Given I am on the change site name page
  And I fill in "site_name" with "Harrow Community Network"
  And I press "Change"
  Then I should be on the home page
  And the site name should be "Harrow Community Network"
  And the site name should not be "Local Support"

