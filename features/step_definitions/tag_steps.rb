When(/^"([^"]*)" adds the tag "([^"]*)" to "([^"]*)" in list "([^"]*)"$/) do |username, tag, todo, list|
    user = User.find_by username: username
    list = user.lists.find_by name: list
    todo = list.todos.find_by name: todo

    post "/list/#{list.id}/item/#{todo.id}/tag", "{\"name\": \"#{tag}\"}"
end

Then(/^"([^"]*)"'s todo "([^"]*)" in list "([^"]*)" should have (\d+) tag "([^"]*)"$/) do |username, todo, list, n, tag|
    user = User.find_by username: username
    list = user.lists.find_by name: list
    todo = list.todos.find_by name: todo

    expect(todo.tags.size).to eq(n.to_i)
    expect(todo.tags[0].name).to eq(tag)
end

Given(/^"([^"]*)"'s todo "([^"]*)" in list "([^"]*)" has tag "([^"]*)"$/) do |username, todo, list, tag|
    user = User.find_by username: username
    list = user.lists.find_by name: list
    todo = list.todos.find_by name: todo
    tag = Tag.find_or_create_by name: tag
    todo.todo_tags.create(tag_id: tag.id, todo_id: todo.id)
end

When(/^"([^"]*)" removes the tag "([^"]*)" from "([^"]*)" in "([^"]*)"$/) do |username, tag, todo, list|
    user = User.find_by username: username
    list = user.lists.find_by name: list
    todo = list.todos.find_by name: todo
    tag = Tag.find_by name: tag
    todo_tag = TodoTag.find_by tag_id: tag.id

    delete "/list/#{list.id}/item/#{todo.id}/tag/#{todo_tag.id}"
end