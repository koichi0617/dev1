class AddAToNotifications < ActiveRecord::Migration[5.1]
  def change
    rename_column :notifications, :item_id, :micropost_id
  end
end
