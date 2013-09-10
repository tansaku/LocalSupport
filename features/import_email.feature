Feature: import email addresses
  As a Site Admin
  So that I enable contacting organizations
  I want to import emails for those organizations that do not have emails

Background: organizations have been added to database
  Given the following organizations exist:
    | name              | description              | address        | postcode | website       |
    | I love dogs       | loves canines            | 34 pinner road | HA1 4HZ  | http://a.com/ |
    | I love cats       | loves felines            | 64 pinner road | HA1 4HA  | http://b.com/ |
    | I hate animals    | hates birds and beasts   | 84 pinner road | HA1 4HF  | http://c.com/ |
  And a file exists:
    | name              | email               |
    | name              | email               |
    | I love dogs       | admin@dogs.com      |
    | I love cats       | admin@cats.com      |
    | I hate animals    | admin@cruelty.com   |

  Scenario: import email addresses
    Given that I import emails
    Then "I love dogs" should have email "admin@dogs.com"
    Then "I love cats" should have email "admin@cats.com"
    Then "I hate animals" should have email "admin@cruelty.com"
