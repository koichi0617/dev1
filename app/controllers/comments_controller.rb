class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]
 
  def new
    @micropost = Micropost.find(params[:micropost_id])
    if logged_in?
      @comment = Comment.new
      @comment.user_id = current_user.id
    else
      render template: 'sessions/new'
    end
  end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment_micropost = @comment.micropost
    respond_to do |format|
      if @comment.save
        format.html { redirect_to micropost_url, notice: '投稿されました' }
        format.json { render :show, status: :created, location: @comment }
        format.js { @status = "success"}
        flash[:success] = 'コメントを投稿しました!'
        @comment_micropost.create_notification_comment!(current_user, @comment.id)
        redirect_back(fallback_location: root_path) 
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
        flash[:danger] = "コメント投稿に失敗しました"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "削除されました"
    redirect_back(fallback_location: root_path) 
  end


  private

    def comment_params
      params.require(:comment).permit(:micropost_id, :user_id, :comment_id, :content, :picture)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to micropost_url if @comment.nil?
    end

end
