class Todo < ActiveRecord::Base
  belongs_to :list
  has_many :tags, through: :todo_tag
end
