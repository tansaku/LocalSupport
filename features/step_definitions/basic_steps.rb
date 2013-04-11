require 'webmock/cucumber'

Given /^I am on the charity page for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  visit organization_path org1.id
end

Given /^I am on the edit charity page for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  visit edit_organization_path org1.id
end

Then /^I should see the donation_info URL for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  page.should have_link "Donate to #{org1.name} now!", :href => org1.donation_info
end

Then /^I should not see the donation_info URL for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  page.should_not have_link "Donate to #{org1.name} now!"
  page.should have_content "We don't yet have any donation link for them."
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^I should see "([^"]*?)", "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2, name3|
  check_map([name1,name2,name3])
end

Then /^I should see "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2|
  check_map([name1,name2])
end

def check_map(names)
  # this is specific to cehcking for all items when we want a generic one
  #page.should have_xpath "//script[contains(.,'Gmaps.map.markers = #{Organization.all.to_gmaps4rails}')]"

  names.each do |name|
    #org = Organization.find_by_name(name)
    Organization.all.to_gmaps4rails.should match(name)
  end
end

Then /^I should see search results for "(.*?)" in the map$/ do |search_terms|
  page.should have_xpath "//script[contains(.,'Gmaps.map.markers = #{Organization.search_by_keyword(search_terms).to_gmaps4rails}')]"
end

Given /the following organizations exist/ do |organizations_table|
  geocoding = File.read "test/fixtures/34_pinner_road.json"
  stub_request(:get, %r{maps.googleapis.com/maps/api/geocode/json?.*}).
  to_return(status => 200, :body => geocoding, :headers => {})
  organizations_table.hashes.each do |org|    
    Organization.create! org
  end
end

Given /^I am on the home page$/ do
  visit "/"
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content text
end


When /^I search for "(.*?)"$/ do |text|
  fill_in 'q', with: text
  click_button 'Search'
end

Then /^I should see contact details for "([^"]*?)"$/ do |text|
  page.should have_content text
end

Then /^I should see contact details for "([^"]*?)" and "(.*?)"$/ do |text1, text2|
  page.should have_content text1
  page.should have_content text2
end


Then /^I should see contact details for "([^"]*?)", "([^"]*?)" and "(.*?)"$/ do |text1, text2, text3|
  page.should have_content text1
  page.should have_content text2
  page.should have_content text3
end

When /^I edit the charity address to be "(.*?)"$/ do |address|
   fill_in('organization_address',:with => address)
end

Given /^I press "(.*?)"$/ do |button|
  click_button(button)
end

Then /^the coordinates for "(.*?)" and "(.*?)" should be the same/ do | org1_name, org2_name|
  matches = page.html.match %Q<{\\"description\\":\\"#{org1_name}\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org1_lat = matches[1]
  org1_lng = matches[2]
  page.html.should have_content  %Q<{"description":"#{org2_name}","lat":#{org1_lat},"lng":#{org1_lng}}>
end
