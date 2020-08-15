class StaticPagesController < ApplicationController
  def home
  end

  def index
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = Micropost.includes(:user).order("created_at DESC").page(params[:page])
  end

  def show
    @micropost = Micropost.find_by(id:params[:id])
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
      @micropost.save
      if @micropost.save
        flash[:success] = "投稿されました"
        redirect_to index_path
      else
        @feed_items = []
        render 'static_pages/index'
      end
    else
      render template: 'sessions/new'
    end
  end

end
