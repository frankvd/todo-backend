require "bcrypt"
require "roar/json/hal"

# User model
class User < ActiveRecord::Base
    include BCrypt

    has_many :lists

    def password
        @password ||= Password.new(password_hash)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
      end
end

# User representer
module UserRepresenter
    include Roar::JSON::HAL

    property :id
    property :username
    collection :lists, extend: ListRepresenter, class: List, embedded: true

    link :self do
        ENV["host"] + "/me"
    end

    link :lists do
        ENV["host"] + "/lists"
    end

    link :tags do
        ENV["host"] + "/tags"
    end
end
