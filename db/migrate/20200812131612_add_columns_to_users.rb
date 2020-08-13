class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :faculty, :string
    add_column :users, :major, :string
  end
end
