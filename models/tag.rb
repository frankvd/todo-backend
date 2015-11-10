class Tag < ActiveRecord::Base
  has_many :todos, through: :todo_tag
end
