class MessagesController < ApplicationController
  before_action :set_room, only: [:create, :edit, :update, :destroy]

  def create
    @room = Room.find(params[:message][:room_id])
    @message = @room.messages.build(message_params)
    @message.user_id = current_user.id
    if @message.save
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "メッセージ送信に失敗しました"
      redirect_back(fallback_location: root_path) #元のページに戻る
    end
  end

  private

    def set_room
        @room = Room.find(params[:message][:room_id])
    end

    def gets_entries_all_messages
        @messages = @room.messages.includes(:user).order("created_at asc")
        @entries = @room.entries
    end

    def message_params
        params.require(:message).permit(:user_id, :message, :room_id).merge(user_id: current_user.id)
    end
end
