class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true #usersテーブルのemailカラムにインデックスを追加する
  end
end
