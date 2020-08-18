class AddAToSolves < ActiveRecord::Migration[5.1]
  def change
    rename_table :solves, :resolves
  end
end
