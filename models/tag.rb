require "roar/json/hal"

class Tag < ActiveRecord::Base
    has_many :todo_tags
    has_many :todos, through: :todo_tags
end

module TagRepresenter
    include Roar::JSON::HAL

    property :id
    property :name
end
