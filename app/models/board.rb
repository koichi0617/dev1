class Board < ApplicationRecord
  belongs_to :user, optional: true
  #has_many :comments, dependent: :destroy, inverse_of: :board
  default_scope -> { order(created_at: :desc) } #作成日時から降順に並べる
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
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
