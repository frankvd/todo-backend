Given(/^the user "([^"]*)" exists with the password "([^"]*)"$/) do |username, password|
    user = User.new
    user.username = username
    user.password = password
    user.save
end

When(/^"([^"]*)" logs in with the password "([^"]*)"$/) do |username, password|
    post "/login", "{\"username\": \"#{username}\", \"password\": \"#{password}\"}"
end

Then(/^the user "([^"]*)" should be logged in$/) do |arg1|
    expect(last_response.header["Set-Cookie"]).to match(/rack.session/)
end
