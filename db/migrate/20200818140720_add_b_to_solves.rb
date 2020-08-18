class AddBToSolves < ActiveRecord::Migration[5.1]
  def change
    add_reference :microposts, :resolve, foreign_key: true
    change_column :microposts, :resolve_id, :integer, :default => 2
  end
end
