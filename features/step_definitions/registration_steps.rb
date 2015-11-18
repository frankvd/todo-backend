When(/^"([^"]*)" registers an account with password "([^"]*)"$/) do |username, password|
    post "/register", "{\"username\": \"#{username}\", \"password\": \"#{password}\"}"
end

Then(/^the user "([^"]*)" should exist$/) do |username|
    user = User.find_by username: username
    expect(user).to_not be_nil
end

Given(/^user "([^"]*)" exists$/) do |username|
  user = User.new
  user.username = username
  user.save()
end

Then(/^the registration should fail$/) do
    expect(last_response.status).to eq(400)
end
