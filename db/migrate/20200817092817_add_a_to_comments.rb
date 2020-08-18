class AddAToComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :comments, :user, foreign_key: true
    change_column_default :microposts, :solve, from: true, to: false
  end
end
