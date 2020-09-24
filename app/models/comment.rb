class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_many :children, :class_name => "Comment", :foreign_key => "comment_id", dependent: :destroy
  belongs_to :parent, :class_name => "Comment", :foreign_key => "comment_id", optional: true
  mount_uploader :picture1, PictureUploader
  mount_uploader :picture2, PictureUploader
  mount_uploader :picture3, PictureUploader
  validates :content, presence: true, length: { maximum: 500 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture1.size > 5.megabytes
        errors.add(:picture1, "容量は5MBまでです")
      elsif picture2.size > 5.megabytes
        errors.add(:picture2, "容量は5MBまでです")
      elsif picture3.size > 5.megabytes
        errors.add(:picture3, "容量は5MBまでです")
      end
    end
end
