Feature: Local Resident looking to donate
  As a local resident
  So that I can help local charities
  I want to find out how I can donate
  Tracker story ID: https://www.pivotaltracker.com/story/show/45392735

Background: organizations have been added to database
  
  Given the following organizations exist:
    | name                            | donation_info                      | address        |
    | Harrow Bereavement Counselling  | www.harrow-bereavment.co.uk/donate | 34 pinner road |
    | Indian Elders Associaton        | www.indian-elders.co.uk/donate     | 64 pinner road |
    | Age UK                          | www.age-uk.co.uk/donate            | 84 pinner road |
    | Friendly                        |                                    | 34 pinner road | 
    | Friendly Charity                |                                    | 83 pinner road |

  #adding this to the above table makes the donation_info not be nil.  need to find better solution
  #Given the following organizations exist:
    #|name             | address        |
    #|Friendly Charity | 83 pinner road |

  Given the following users are registered:
  | email             | password | admin | organization | confirmed_at |
  | jcodefx@gmail.com | pppppppp | false | Friendly     | 2007-01-01  10:00:00 |
  | jcodefx2@gmail.com| pppppppp | false |              | 2007-01-01  10:00:00 |

Scenario: Org page of an organization with donation info URL
  Given I am on the charity page for "Age UK"
  Then I should see the donation_info URL for "Age UK"

Scenario: Org page of an organization without donation info URL 
  Given I am on the charity page for "Friendly Charity"
  Then I should not see the donation_info URL for "Friendly Charity"

Scenario: Successfully change the donation url for a charity
  Given I am on the sign in page
  And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  Given I am on the edit charity page for "Friendly"
  And I edit the donation url to be "http://www.friendly.com/donate"
  And I press "Update Organization"
  Then I should be on the charity page for "Friendly"
  And I should see "Organization was successfully updated"
  And the donation_info URL for "Friendly" should refer to "http://www.friendly.com/donate"

Scenario: Unsuccessfully change the donation url for a charity
  #Given I am signed in as a charity worker unrelated to "Friendly" with password "pppppppp"
  Given I am on the sign in page
  And I sign in as "jcodefx2@gmail.com" with password "pppppppp"
  Given I am furtively on the edit charity page for "Friendly"
  And I edit the donation url to be "http://www.friendly.com/donate"
  And I press "Update Organization"
  Then I should be on the charity page for "Friendly"
  And I should see "You don't have permission"
  And I should see "We don't yet have any donation link for them."

  
  


