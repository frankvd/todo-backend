Given(/^"([^"]*)" is logged in$/) do |username|
    user = User.new
    user.username = username
    user.password = "test"
    user.save

    post "/login", "{\"username\": \"#{username}\", \"password\": \"test\"}"
end

When(/^"([^"]*)" adds a list named "([^"]*)"$/) do |arg1, name|
  post "/list", "{\"name\": \"#{name}\"}"
end

Then(/^"([^"]*)" should have (\d+) list named "([^"]*)"$/) do |username, n, name|
  user = User.find_by username: username

  expect(user.lists.size).to eq(1)
  expect(user.lists[0].name).to eq(name)
end