class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :solve]
  before_action :correct_user,   only: [:destroy, :solve]

  def index
    @feed_items = params[:major_id].present? ? Micropost.where(major_id: params[:major_id]) : Micropost.all
    @feed_items = params[:resolve_id].present? ? @feed_items.where(resolve: params[:resolve_id]) : @feed_items
    @feed_items = params[:keyword].present? ? @feed_items.where("subject LIKE ?", "%#{params[:keyword]}%") : @feed_items
    @feed_items = @feed_items.page(params[:page])
    @like = Micropost.likes.find_by(micropost_id: params[:id], user_id: current_user.id)
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
      respond_to do |format|
        if @micropost.save
          format.html { redirect_to microposts_url, notice: '投稿されました' }
          format.json { render :show, status: :created, location: @micropost }
          format.js { @status = "success"}
          redirect_to microposts_url
        else
          format.html { render :new }
          format.json { render json: @micropost.errors, status: :unprocessable_entity }
          format.js { @status = "fail" }
          @feed_items = []
          render 'microposts/index'
        end
      end
    else
      render template: 'sessions/new'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    flash[:success] = "削除されました"
    redirect_to request.referrer || microposts_url
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = @micropost.comments.where(comment_id: nil)
    @comment  = @micropost.comments.build if current_user
    @comment.user_id = current_user.id
    @like = Like.where(micropost_id: params[:id])
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
