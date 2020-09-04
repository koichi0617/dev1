require 'sendgrid-ruby'
include SendGrid

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
      # UserMailer.with(user: @user).account_activation.deliver_later
      logger.debug('AAAA')
      from = SendGrid::Email.new(email: 'agora.kumamoto@gmail.com')
      to = SendGrid::Email.new(email: 'k.agoyh.neko@icloud.com')
      subject = '【アゴラ】認証メール'
      content = SendGrid::Content.new(
        type: 'text/plain',
        value: '

        この度は、「アゴラ」にお申し込み頂きまして
        誠にありがとうございます。

        お申し込み頂きましたアカウント情報は以下となります。

        　ログインID：○○○○○
        　パスワード：個人情報のため表示を伏せています

        ご本人様確認のため、下記URLへ「24時間以内」にアクセスし
        アカウントの本登録を完了させて下さい。
        https://○○○/○○○.aspx?key=Qwertyuioplkjhgfdsazxcvbnm1234567890

        ※当メール送信後、24時間を超過しますと、セキュリティ保持のため有効期限切れとなります。
        　その場合は再度、最初からお手続きをお願い致します。

        ※お使いのメールソフトによってはURLが途中で改行されることがあります。
        　その場合は、最初の「http://」から末尾の英数字までをブラウザに
        　直接コピー＆ペーストしてアクセスしてください。

        ※当メールは送信専用メールアドレスから配信されています。
        　このままご返信いただいてもお答えできませんのでご了承ください。

        ※当メールに心当たりの無い場合は、誠に恐れ入りますが
        　破棄して頂けますよう、よろしくお願い致します。
        '
      )
      mail = SendGrid::Mail.new(from, subject, to, content)
      logger.debug('BBBB')
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      logger.debug(response.status_code)
      logger.debug(response.body)
      logger.debug(response.headers)
      logger.debug('CCCC')
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

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
