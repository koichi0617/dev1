class ChangeRooms < ActiveRecord::Migration[5.1]
  def change
    drop_table :rooms do |t|

      t.timestamps
    end
    drop_table :messages do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.text :message, null: false

      t.timestamps
    end
    drop_table :entries do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
