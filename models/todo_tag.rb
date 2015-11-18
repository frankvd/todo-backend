class TodoTag < ActiveRecord::Base
    belongs_to :todo
    belongs_to :tag

    def tag_id
        tag.id
    end

    def tag_name
        tag.name
    end
end


module TodoTagRepresenter
    include Roar::JSON::HAL

    property :tag_id, as: :id
    property :tag_name, as: :name

    link :self do
        ENV["host"] + "/lists/#{todo.list.id}/items/#{todo.id}/tags/#{tag.id}"
    end

    link :todo do
        ENV["host"] + "/lists/#{todo.list.id}/items/#{todo.id}"
    end
end
