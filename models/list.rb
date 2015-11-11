require "roar/json/hal"

class List < ActiveRecord::Base
  belongs_to :user
  has_many :todos
end

module ListRepresenter
    include Roar::JSON::HAL

    property :id
    property :name
    collection :todos, extend: TodoRepresenter, class: Todo

    link :self do
        ENV["host"] + "/list/#{id}"
    end
end
