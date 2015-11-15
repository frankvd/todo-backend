require "roar/json/hal"

class List < ActiveRecord::Base
  belongs_to :user
  has_many :todos
end

module ListRepresenter
    include Roar::JSON::HAL

    property :id
    property :name
    collection :todos, extend: TodoRepresenter, class: Todo, embedded: true

    link :me do
        ENV["host"] + "/me"
    end

    link :self do
        ENV["host"] + "/lists/#{id}"
    end
    
    link :items do
        ENV["host"] + "/lists/#{id}/items"
    end
end
