class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :major, optional: true
  belongs_to :resolve, optional: true
  has_many :comments, dependent: :destroy, inverse_of: :micropost
  has_many :likes, dependent: :destroy, inverse_of: :micropost
  default_scope -> { order(created_at: :desc) } #作成日時から降順に並べる
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  validate  :picture_size

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "容量は5MBまでです")
      end
    end
end
