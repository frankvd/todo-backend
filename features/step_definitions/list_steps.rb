Given(/^"([^"]*)" is logged in$/) do |username|
    user = User.new
    user.username = username
    user.password = "test"
    user.save

    post "/login", "{\"username\": \"#{username}\", \"password\": \"test\"}"
end

When(/^"([^"]*)" adds a list named "([^"]*)"$/) do |arg1, name|
  post "/lists", "{\"name\": \"#{name}\"}"
end

Then(/^"([^"]*)" should have (\d+) list named "([^"]*)"$/) do |username, n, name|
  user = User.find_by username: username

  expect(user.lists.size).to eq(n.to_i)
  expect(user.lists[0].name).to eq(name)
end

Given(/^"([^"]*)" has a list named "([^"]*)"$/) do |username, name|
    user = User.find_by username: username
    list = List.new
    list.user = user
    list.name = name
    list.save
end

When(/^"([^"]*)" removes the list "([^"]*)"$/) do |username, name|
    list = List.find_by name: name
    delete "/lists/#{list.id}"
end

When(/^"([^"]*)" renames the list "([^"]*)" to "([^"]*)"$/) do |username, old_name, new_name|
    list = List.find_by name: old_name
    post "/lists/#{list.id}", "{\"name\": \"#{new_name}\"}"
end
