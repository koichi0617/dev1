include AccountActivationsHelper
require 'securerandom'
require 'net/http'
require 'uri'
require 'json'
require 'jwt'

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
    @user = User.find(current_user.id)
    #POSTを送ってレスポンスを受け取る
    uri = URI.parse(request.url) #現在のURLを分割して取得
    q_hash = CGI.parse(uri.query)
    code = q_hash['code'].first
    state = q_hash['state'].first

    res_uri = URI.parse("https://api.line.me/oauth2/v2.1/token")
    req = Net::HTTP::Post.new(res_uri.path)
    req.content_type = "application/x-www-form-urlencoded"
    req.set_form_data(:grant_type => "authorization_code", 
                      :code => code, 
                      :redirect_uri => ENV['LINE_REDIRECT_URL'], 
                      :client_id => ENV['LINE_LOGIN_ID'], 
                      :client_secret => ENV['LINE_LOGIN_SECRET'])
    req_options = {
      use_ssl: res_uri.scheme == "https"
    }
    response = Net::HTTP.start(res_uri.hostname, res_uri.port, req_options) do |http|
      http.request(req)
    end
    res_body = JSON.parse(response.body, quirks_mode: true)
    id_token = res_body['id_token']
    #受け取ったid_tokenをデコードしてopen_idを取得したい
    decoded_id_token = JWT.decode(id_token, nil, false, { algorithm: 'HS256' })

    #usersテーブルに値を格納
    @user.update( line_id: decoded_id_token[0]['sub'] )
  end

  def line
    nonce = SecureRandom.hex(16)
    line_url = ENV['LINE_LOGIN_URL'] + '&client_id=' + ENV['LINE_LOGIN_ID'] + '&redirect_uri=' + ENV['LINE_REDIRECT_URL'] + '&nonce=' + nonce
    redirect_to line_url
  end

  def line_cancel
    @user = User.find(current_user.id)
    @user.update(line_id: nil)
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
