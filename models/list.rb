# List model
class List < ActiveRecord::Base
  belongs_to :user
  has_many :todos
end

# List representer without embedded items
class ListRepresenter < Roar::Decorator
    include Roar::JSON::HAL

    property :id
    property :name

    link :me do
        ENV["host"] + "/me"
    end

    link :self do
        ENV["host"] + "/lists/#{represented.id}"
    end

    link :items do
        ENV["host"] + "/lists/#{represented.id}/items"
    end
end

# List representer with embedded items
class ListWithTodosRepresenter < ListRepresenter
    collection :todos, extend: TodoRepresenter, class: Todo, embedded: true
end
