class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = Micropost.includes(:user).order("created_at DESC").page(params[:page])
    #@feed_items = params[:major_id].present? ? Micropost.find_by(major_id: params[:major_id]) : Micropost.all
  end

  def new
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      render template: 'sessions/new'
    end
  end

  def create
    if logged_in?
      @micropost = current_user.microposts.build(micropost_params)
      if @micropost.save
        flash[:success] = "投稿されました"
        redirect_to microposts_url
      else
        @feed_items = []
        render 'microposts/index'
      end
    else
      render template: 'sessions/new'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "削除されました"
    redirect_to request.referrer || root_url
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comment = Comment.new(micropost_id: @micropost.id)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
