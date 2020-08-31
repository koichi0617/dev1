class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :micropost_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked

      t.timestamps
    end
  end
end
