Feature: Sign out
  As a logged-in User
  So that noone else can use my account
  I want to sign out
  Tracker story ID: https://www.pivotaltracker.com/story/show/47373975

#Scenario: Sign out
#  Given PENDING that I am logged in as any user
#  When I follow sign out
#  Then I should be on the public home page

Scenario: Sign out
  Given cookies are approved
  And that I am logged in as any user
  When I sign out
  Then I should be on the home page
  Then I should not be signed in as any user
