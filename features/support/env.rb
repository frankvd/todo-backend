# features/support/env.rb

ENV['RACK_ENV'] = 'test'
ENV['db'] = File.expand_path '../../../testing.sqlite3', __FILE__

require 'rubygems'
require 'rack/test'
require 'rake'
require 'rspec/expectations'
require 'webrat'

require File.expand_path '../../../app.rb', __FILE__

Webrat.configure do |config|
  config.mode = :rack
end

class WebratMixinExample
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body, :assert

  def app
    Sinatra::Application
  end
end

World{WebratMixinExample.new}

Before do
    Tag.delete_all
    Todo.delete_all
    List.delete_all
    User.delete_all
end
