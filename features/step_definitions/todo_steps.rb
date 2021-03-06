When(/^"([^"]*)" adds "([^"]*)" to "([^"]*)"$/) do |username, todo, list|
    user = User.find_by username: username
    list = user.lists.where(name: list).first
    post "/lists/#{list.id}/items", "{\"name\": \"#{todo}\"}"
end

Then(/^"([^"]*)"'s list "([^"]*)" should have (\d+) todo named "([^"]*)"$/) do |username, list, n, todo|
    user = User.find_by username: username
    list = user.lists.where(name: list).first

    expect(list.todos.size).to eq(n.to_i)
    expect(list.todos[0].name).to eq(todo)
end

Given(/^"([^"]*)"'s list "([^"]*)" has a todo named "([^"]*)"$/) do |username, list, todo|
    user = User.find_by username: username
    list = user.lists.where(name: list).first
    list.todos.create(name: todo)
end

When(/^"([^"]*)" removes "([^"]*)" from "([^"]*)"$/) do |username, todo, list|
    user = User.find_by username: username
    list = user.lists.where(name: list).first
    todo = list.todos.where(name: todo).first

    delete "/lists/#{list.id}/items/#{todo.id}"
end

When(/^"([^"]*)" renames "([^"]*)" from "([^"]*)" to "([^"]*)"$/) do |username, old_name, list, new_name|
    user = User.find_by username: username
    list = user.lists.where(name: list).first
    todo = list.todos.where(name: old_name).first

    post "/lists/#{list.id}/items/#{todo.id}", "{\"name\": \"#{new_name}\"}"
end
