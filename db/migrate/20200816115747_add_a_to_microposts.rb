class AddAToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_reference :microposts, :major, foreign_key: true
  end
end
