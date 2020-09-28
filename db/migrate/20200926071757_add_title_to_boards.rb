class AddTitleToBoards < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :subject, :string
    add_column :users, :icon, :string
  end
end
