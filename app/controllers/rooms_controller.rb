class RoomsController < ApplicationController

  def index
    #@rooms = current_user.rooms.includes(:messages).order("messages.created_at desc")
    #@room = current_user.rooms.find(params[:room_id])
    #@entries = @room.entries

    # ログインユーザーが属しているルームのIDを全て抽出して配列化
    current_entries = current_user.entries
    my_room_ids = []
    current_entries.each do |entry|
      my_room_ids << entry.room.id
    end
    # さらにuser_idがログインユーザーでは無いレコードを抽出
    @another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: current_user.id)
  end

  def create
    @room = Room.create
    @joinCurrentUser = Entry.create(user_id: current_user.id, room_id: @room.id)
    @joinUser = Entry.create(join_room_params)
    @first_message = @room.messages.create(user_id: current_user.id, message: "こんにちは！")
    redirect_to room_path(@room.id)
  end

  def show
    @user = User.find(params[:id])
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
        @messages = @room.messages.includes(:user).order("created_at asc")
        @message = Message.new
        @entries = @room.entries
    else
        redirect_back(fallback_location: root_path)
    end
  end

  private

    def join_room_params
        params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
    end

    def correct_user
        @room = current_user.rooms.find_by(id: params[:id])
        redirect_to users_url if @room.nil?
    end

end
