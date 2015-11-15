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

    link :self do
        ENV["host"] + "/lists/#{list.id}/items/#{id}"
    end

    link :list do
        ENV["host"] + "/lists/#{list.id}"
    end

    link :tags do
        ENV["host"] + "/lists/#{list.id}/items/#{id}/tags"
    end
end
