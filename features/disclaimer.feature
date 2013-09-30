Feature: Disclaimer about not being able to guarantee accuracy of sites content and notice about being beta site
  As the system owner
  So that I can avoid any liability
  I want to show a disclaimer page
  Tracker story ID: https://www.pivotaltracker.com/story/show/49757817

Background: organizations have been added to database

  Given the following organizations exist:
    | name             | address        |
    | Friendly Charity | 83 pinner road |
  Given the following pages exist:
    | name       | permalink  | content |
    | Disclaimer | disclaimer | ghi789  |

Scenario: the disclaimer page is accessible from the charity search page
  Given I am on the charity search page
  When I follow "Disclaimer"
  Then I should see "ghi789"

Scenario: the disclaimer page is accessible from the charities page
  Given I am on the home page
  When I follow "Disclaimer"
  Then I should see "ghi789"

Scenario: the disclaimer page is accessible from the new charity page
  Given I am on the new charity page
  When I follow "Disclaimer"
  Then I should see "ghi789"

Scenario: the disclaimer page is accessible from the edit charity page for "Friendly Charity"
  Given I am furtively on the edit charity page for "Friendly Charity"
  When I follow "Disclaimer"
  Then I should see "ghi789"

Scenario: the disclaimer page is accessible from the charity page
  Given I am on the charity page for "Friendly Charity"
  When I follow "Disclaimer"
  Then I should see "ghi789"
