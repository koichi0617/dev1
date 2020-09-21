class Micropost < ApplicationRecord
  require 'line/bot'
  belongs_to :user
  belongs_to :major, optional: true
  belongs_to :resolve, optional: true
  has_many :comments, dependent: :destroy, inverse_of: :micropost
  has_many :likes, dependent: :destroy, inverse_of: :micropost
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) } #作成日時から降順に並べる
  mount_uploader :picture1, PictureUploader
  mount_uploader :picture2, PictureUploader
  mount_uploader :picture3, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  validate  :picture_size

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  #いいね時の通知メソッド
  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      micropost_id: id,
      visited_id: user_id,
      action: "like"
    )
    notification.save if notification.valid?
    notice(user_id)
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
        save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分のコメントは通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
    notice(visited_id)
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_BOT_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
  end

  def notice(visited_id)
    @user = User.find_by(id: visited_id)
    @notifications = @user.passive_notifications

    notification = @notifications.last
    case notification.action
    when "like" then
      message = {
        type: 'text',
        text: "#{notification.visitor.name}があなたの投稿にいいねしました"
      }
    when "comment" then
      message = {
        type: 'text',
        text: "#{notification.visitor.name}があなたの投稿にコメントしました"
      }
    end

    response = client.push_message(@user.line_id, message)
    p response
  end

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
