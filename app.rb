require "sinatra"
require "sinatra/activerecord"
require "./models/user.rb"
require "./models/list.rb"
require "./models/todo.rb"
require "./models/tag.rb"
require "./models/todo_tag.rb"

if !ENV["db"].present? then
    ENV["db"] = "db.sqlite3"
end

set :database, {adapter: "sqlite3", database: ENV["db"]}

use Rack::Session::Pool, :expire_after => 604800

get "/" do
    "{\"message\": \"hoi\"}"
end

post "/register" do
    req = MultiJson.load(request.body.read)
    user = User.new
    user.username = req["username"]
    user.password = req["password"]
    begin
        success = user.save
    rescue
        success = false
    end

    MultiJson.dump({:success => success})
end

post "/login" do
    req = MultiJson.load(request.body.read)
    user = User.find_by! username: req["username"]

    if user.password == req["password"] then
        session[:user_id] = user.id
        success = true
    else
        success = false
    end

    MultiJson.dump({:success => success})
end

post "/list" do
    req = MultiJson.load(request.body.read)

    user = User.find(session[:user_id])
    puts req["name"]
    puts user.id

    list = List.new
    list.name = req["name"]
    list.user = user
    list.save
end

delete "/list/:id" do |id|
    user = User.find(session[:user_id])

    user.lists.destroy(id)

    "success"
end

post "/list/:id/item" do |id|
    req = MultiJson.load(request.body.read)

    user = User.find(session[:user_id])
    list = user.lists.find(id)
    list.todos.create(name: req["name"])

    "success"
end

delete "/list/:list_id/item/:item_id" do |list_id, item_id|
    user = User.find(session[:user_id])
    list = user.lists.find(list_id)
    list.todos.destroy(item_id)

    "success"
end

post "/list/:list_id/item/:item_id/tag" do |list_id, item_id|
    req = MultiJson.load(request.body.read)
    user = User.find(session[:user_id])

    tag = Tag.find_or_create_by name: req["name"]

    list = user.lists.find(list_id)
    todo = list.todos.find(item_id)
    todo.todo_tags.create(tag_id: tag.id, todo_id: todo.id)

    "success"
end

delete "/list/:list_id/item/:item_id/tag/:tag_id" do |list_id, item_id, tag_id|
    user = User.find(session[:user_id])

    list = user.lists.find(list_id)
    todo = list.todos.find(item_id)
    todo.todo_tags.destroy(tag_id)

    "success"
end
