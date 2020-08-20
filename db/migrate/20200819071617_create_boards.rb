class CreateBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.string :picture
      t.references :user, foreign_key: true

      t.timestamps

    end
    add_reference :comments, :board, foreign_key: true

  end
end
