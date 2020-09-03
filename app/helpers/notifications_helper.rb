module NotificationsHelper

  def notification_form(notification)
     @visitor = notification.visitor
     @comment = nil
     your_micropost = link_to 'あなたの投稿', micropost_path(notification), style:"font-weight: bold;"
     @visitor_comment = notification.comment_id
     #notification.actionがlikeかcommentか
     case notification.action
       when "like" then
         tag.a(notification.visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:micropost_path(notification.micropost_id), style:"font-weight: bold;")+"にいいねしました"
       when "comment" then
           @comment = Comment.find_by(id: @visitor_comment)&.content
           tag.a(@visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:micropost_path(notification.micropost_id), style:"font-weight: bold;")+"にコメントしました"
     end
   end

   def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
