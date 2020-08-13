class StaticPagesController < ApplicationController
  def home
  end

  def index
    @feed_items = Micropost.includes(:user).order("created_at DESC").page(params[:page])
    @shibori = Micropost.where()
  end

  def detail
  end

  def post
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
