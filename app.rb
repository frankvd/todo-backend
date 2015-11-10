require "sinatra"
require "sinatra/activerecord"
require "./models/user.rb"

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
    puts req["username"]
    user = User.find_by! username: req["username"]
    puts user
    if user.password == req["password"] then
        session[:user_id] = user.id
        success = true
    else
        success = false
    end

    MultiJson.dump({:success => success})
end
