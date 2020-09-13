class AddLineIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :line_id, :string
  end
end
