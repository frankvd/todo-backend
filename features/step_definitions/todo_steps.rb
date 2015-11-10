When(/^"([^"]*)" adds "([^"]*)" to "([^"]*)"$/) do |username, todo, list|
    user = User.find_by username: username
    list = user.lists.where(name: list).first
    post "/list/#{list.id}/item", "{\"name\": \"#{todo}\"}"
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

    delete "/list/#{list.id}/item/#{todo.id}"
end
