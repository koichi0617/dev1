class CreateSolves < ActiveRecord::Migration[5.1]
  def change
    create_table :solves do |t|
      t.string :name
      t.boolean :solve
    end
  end
end
