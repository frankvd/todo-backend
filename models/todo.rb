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

    collection :todo_tags, extend: TodoTagRepresenter, class: Tag, as: :tags, embedded: true

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

class TodoCollection
    def initialize(todos)
        @todos = todos
    end

    def id
        0
    end

    def name=(val)
        @name = val
    end

    def name
        @name
    end

    def todos
        @todos
    end
end
