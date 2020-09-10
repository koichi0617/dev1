include AccountActivationsHelper
require 'securerandom'

class UsersController < ApplicationController
  #edit,updateアクションを行う前にログインしているか、正しいアカウントかを確認
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = params[:major_id].present? ? User.where(major_id: params[:major_id]) : User.all
    @users = params[:keyword].present? ? @users.where("name LIKE ?", "%#{params[:keyword]}%") : @users
    @users = @users.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @like_microposts = @user.like_microposts
    @comment_microposts = @user.comment_microposts
    if logged_in?
      @currentUserEntry = Entry.where(user_id: current_user.id)
      @userEntry = Entry.where(user_id: @user.id)
      unless @user.id == current_user.id
        @currentUserEntry.each do |cu|
          @userEntry.each do |u|
            if cu.room_id == u.room_id
              @haveRoom = true
              @roomId = cu.room_id
            end
          end
        end
        unless @haveRoom
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      send_account_velification_mail(@user)
      flash[:info] = "メールを送信しました。アカウントを認証してください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to users_url
  end

  def callback

  end

  def line
    nonce = SecureRandom.hex(16)
    line_url = ENV['LINE_LOGIN_URL'] + '&client_id=' + ENV['LINE_LOGIN_ID'] + '&redirect_uri=' + ENV['LINE_REDIRECT_URL'] + '&nonce=' + nonce
    redirect_to line_url
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :major_id, :password, :password_confirmation, :profile)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
