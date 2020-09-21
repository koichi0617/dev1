class AddColumnToMicroposts < ActiveRecord::Migration[5.1]
  def change
    rename_column :microposts, :picture, :picture1
    add_column :microposts, :picture2, :string
    add_column :microposts, :picture3, :string

    rename_column :comments, :picture, :picture1
    add_column :comments, :picture2, :string
    add_column :comments, :picture3, :string
  end
end
