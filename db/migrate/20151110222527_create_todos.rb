class CreateTodos < ActiveRecord::Migration
    def up
        create_table :lists do |t|
            t.belongs_to :user, index: true
            t.string :name
            t.timestamps null: false
        end

        create_table :todos do |t|
            t.belongs_to :list
            t.string :name
        end

        create_table :tags do |t|
            t.string :name
            t.timestamps null: false
        end

        create_table :todo_tag do |t|
            t.belongs_to :todo, index: true
            t.belongs_to :tag, index: true
            t.timestamps null: false
        end
    end

    def down
        drop_table :lists
        drop_table :todos
        drop_table :tags
        drop_table :todo_tag
    end
end
