class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user

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
