class Todo < ActiveRecord::Base
  belongs_to :list
  has_many :todo_tags
  has_many :tags, through: :todo_tags
end
