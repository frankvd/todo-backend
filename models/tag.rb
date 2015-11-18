require "roar/json/hal"

class Tag < ActiveRecord::Base
    has_many :todo_tags
    has_many :todos, through: :todo_tags
end

module TagRepresenter
    include Roar::JSON::HAL

    property :id
    property :name

    link :todos do
        ENV["host"] + "/tags/#{id}/todos"
    end
end

module TagsRepresenter
    include Roar::JSON::HAL

    collection :tags, extend: TagRepresenter, class: Tag, embedded: true

    link :me do
        ENV["host"] + "/me"
    end
end

class TagCollection
    def initialize(tags)
        @tags = tags
    end

    def tags
        @tags
    end
end
