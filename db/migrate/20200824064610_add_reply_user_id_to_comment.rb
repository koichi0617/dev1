class AddReplyUserIdToComment < ActiveRecord::Migration[5.1]
  def change
    add_reference :comments, :comment, foreign_key: true
  end
end
