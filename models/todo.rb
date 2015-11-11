require "roar/json/hal"

class Todo < ActiveRecord::Base
  belongs_to :list
  has_many :todo_tags
  has_many :tags, through: :todo_tags
end

module TodoRepresenter
    include Roar::JSON::HAL

    property :id
    property :name

    collection :tags, extend: TagRepresenter, class: Tag
end
