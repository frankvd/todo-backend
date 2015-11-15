require 'rubygems'
require 'bundler/setup'
require "sinatra"
require "sinatra/activerecord"
require "./models/todo_tag.rb"
require "./models/tag.rb"
require "./models/todo.rb"
require "./models/list.rb"
require "./models/user.rb"

if !ENV["db"].present? then
    ENV["db"] = "db.sqlite3"
end

ENV["host"] = "http://localhost:3306"

set :database, {adapter: "sqlite3", database: ENV["db"]}
set :port, 3306

before do
    content_type 'application/hal+json'
end

use Rack::Session::Pool, :expire_after => 604800

class Home
    def initialize(cookie)
        @cookie = cookie
    end

    def session_id
        @cookie
    end
end
module HomeRepresenter
    include Roar::JSON::HAL

    property :session_id

    link :login do
        {
            type: "user",
            href: ENV["host"] + "/login"
        }
    end
    link :register do
        {
            type: "user",
            href: ENV["host"] + "/register"
        }
    end
end
get "/" do
    session[:v] = 1
    n = Home.new(request.cookies["rack.session"])
    n.extend(HomeRepresenter)

    n.to_json
end

post "/register" do
    req = MultiJson.load(request.body.read)
    user = User.new
    user.username = req["username"]
    user.password = req["password"]
    begin
        user.save
    rescue
        return MultiJson.dump(error: true)
    end

    user.extend(UserRepresenter)
    user.to_json
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

    user.extend(UserRepresenter)
    user.to_json
end

get "/me" do
    user = User.find(session[:user_id])

    user.extend(UserRepresenter)
    user.to_json
end

get "/lists/:id" do |id|
    user = User.find(session[:user_id])

    list = user.lists.find(id)

    list.extend(ListRepresenter)
    list.to_json
end

post "/lists" do
    req = MultiJson.load(request.body.read)

    user = User.find(session[:user_id])
    puts req["name"]
    puts user.id

    list = List.new
    list.name = req["name"]
    list.user = user
    list.save

    list.extend(ListRepresenter)
    list.to_json
end

delete "/lists/:id" do |id|
    user = User.find(session[:user_id])

    user.lists.destroy(id)

    user.extend(UserRepresenter)
    user.to_json
end

get "/lists/:list_id/items/:item_id" do |list_id, item_id|
    user = User.find(session[:user_id])
    list = user.lists.find(list_id)

    item = list.todos.find(item_id)

    item.extend(TodoRepresenter)
    item.to_json
end

post "/lists/:id/items" do |id|
    req = MultiJson.load(request.body.read)

    user = User.find(session[:user_id])
    list = user.lists.find(id)
    list.todos.create(name: req["name"])

    list.extend(ListRepresenter)
    list.to_json
end

delete "/lists/:list_id/items/:item_id" do |list_id, item_id|
    user = User.find(session[:user_id])
    list = user.lists.find(list_id)
    list.todos.destroy(item_id)

    list.extend(ListRepresenter)
    list.to_json
end

post "/lists/:list_id/items/:item_id/tags" do |list_id, item_id|
    req = MultiJson.load(request.body.read)
    user = User.find(session[:user_id])

    tag = Tag.find_or_create_by name: req["name"]

    list = user.lists.find(list_id)
    todo = list.todos.find(item_id)
    todo.todo_tags.create(tag_id: tag.id, todo_id: todo.id)

    todo.extend(TodoRepresenter)
    todo.to_json
end

delete "/lists/:list_id/items/:item_id/tags/:tag_id" do |list_id, item_id, tag_id|
    user = User.find(session[:user_id])

    list = user.lists.find(list_id)
    todo = list.todos.find(item_id)
    todo.tags.destroy(tag_id)

    todo.extend(TodoRepresenter)
    todo.to_json
end
