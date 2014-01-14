Feature: Approve cookies
  As the system owner
  In order to comply with the EU ePrivacy Directive
  I want all users to be given choice to approve cookie policy
  Tracker story ID: https://www.pivotaltracker.com/story/show/56438038

  Background:
    Given I am on the home page
    And cookies are not approved
    Then I should see an approve cookie policy message

  Scenario: User approving the cookies
    Then I click "Close"
    Then I should not see an approve cookie policy message

  @javascript
  Scenario: Check that cookies can be approved even with JavaScript
    Then I click "Close"
    Then I should not see an approve cookie policy message


