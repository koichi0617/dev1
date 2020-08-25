class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_many :children, :class_name => "Comment", :foreign_key => "comment_id", dependent: :destroy
  belongs_to :parent, :class_name => "Comment", :foreign_key => "comment_id", optional: true
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: { maximum: 500 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "容量は5MBまでです")
      end
    end
end
