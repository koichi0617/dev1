class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :solve]
  before_action :correct_user,   only: [:destroy, :solve]

  def index
    @feed_items = params[:major_id].present? ? Major.find(params[:major_id]).micropost : Micropost.all
    @feed_items = params[:resolve_id].present? ? Resolve.find(params[:resolve_id]).microposts : @feed_items
    @feed_items = @feed_items.page(params[:page])
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

  def solve
    @micropost = Micropost.find(params[:id])
    if @micropost.solve == true
      @micropost.update_attributes(solve: false, resolve_id: 2)
    else
      @micropost.update_attributes(solve: true, resolve_id: 1)
    end
    redirect_to @micropost
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture, :major_id, :subject)
    end

    def solve_params
      params.require(:micropost).permit(:solve)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
