require "rubygems"
require "bundler/setup"
require "roar/json/hal"
require 'roar/decorator'
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

# Set Content-Type and protect non login/register routes
before do
    content_type 'application/hal+json'

    if request.path_info != "/login" and request.path_info != "/register" and request.path_info != "/"
        begin
            @user = User.find(session[:user_id])
        rescue ActiveRecord::RecordNotFound
            throw(:halt, [401, MultiJson.dump(message: "Not logged in")])
        end
    end
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
    rescue ActiveRecord::RecordNotUnique
        status 400
        return MultiJson.dump(message: "User '#{user.username}' already exists")
    end

    user.extend(UserRepresenter)
    user.to_json
end

post "/login" do
    req = MultiJson.load(request.body.read)
    begin
        user = User.find_by! username: req["username"]
    rescue
        status 401
        return MultiJson.dump(message: "Invalid username or password")
    end
    if user.password == req["password"] then
        session[:user_id] = user.id
    else
        status 401
        return MultiJson.dump(message: "Invalid username or password")
    end

    user.extend(UserRepresenter)
    user.to_json
end

get "/me" do
    @user.extend(UserRepresenter)
    @user.to_json
end

get "/lists/:id" do |id|

    list = @user.lists.find(id)

    ListWithTodosRepresenter.new(list).to_json
end

post "/lists" do
    req = MultiJson.load(request.body.read)

    list = List.new
    list.name = req["name"]
    list.user = @user
    list.save

    ListWithTodosRepresenter.new(list).to_json
end

delete "/lists/:id" do |id|
    @user.lists.destroy(id)

    @user.extend(UserRepresenter)
    @user.to_json
end

get "/lists/:list_id/items/:item_id" do |list_id, item_id|
    list = @user.lists.find(list_id)

    item = list.todos.find(item_id)

    item.extend(TodoRepresenter)
    item.to_json
end

post "/lists/:id/items" do |id|
    req = MultiJson.load(request.body.read)

    list = @user.lists.find(id)
    list.todos.create(name: req["name"])

    ListWithTodosRepresenter.new(list).to_json
end

delete "/lists/:list_id/items/:item_id" do |list_id, item_id|
    list = @user.lists.find(list_id)
    list.todos.destroy(item_id)

    ListWithTodosRepresenter.new(list).to_json
end

post "/lists/:list_id/items/:item_id/tags" do |list_id, item_id|
    req = MultiJson.load(request.body.read)

    tag = Tag.find_or_create_by name: req["name"]

    list = @user.lists.find(list_id)
    todo = list.todos.find(item_id)
    todo.todo_tags.create(tag_id: tag.id, todo_id: todo.id)

    todo.extend(TodoRepresenter)
    todo.to_json
end

delete "/lists/:list_id/items/:item_id/tags/:tag_id" do |list_id, item_id, tag_id|

    list = @user.lists.find(list_id)
    todo = list.todos.find(item_id)
    todo.tags.destroy(tag_id)

    todo.extend(TodoRepresenter)
    todo.to_json
end

get "/tags" do
    query = <<-SQL
        SELECT t.* FROM tags t
        LEFT JOIN todo_tags tt ON tt.tag_id = t.id
        LEFT JOIN todos td ON td.id = tt.todo_id
        LEFT JOIN lists l ON l.id = td.list_id
        WHERE l.user_id = ? GROUP BY t.id
    SQL
    tags = Tag.find_by_sql [query, @user.id]

    collection = TagCollection.new(tags)
    collection.extend(TagsRepresenter)
    collection.to_json
end

get "/tags/:id/todos" do |id|
    query = <<-SQL
        SELECT t.* FROM todos t
        LEFT JOIN lists l ON l.id = t.list_id
        LEFT JOIN todo_tags tt on tt.todo_id = t.id
        WHERE l.user_id = ? AND tt.tag_id = ?
    SQL

    todos = Todo.find_by_sql [query, @user.id, id]
    tag = Tag.find(id)
    list = TodoCollection.new(todos)
    list.name = "Todos with tag: #{tag.name}"
    ListWithTodosRepresenter.new(list).to_json
end
