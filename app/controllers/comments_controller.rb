class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'コメントを投稿しました!'
      redirect_back(fallback_location: root_path) 
    else
      flash[:danger] = "コメント投稿に失敗しました"
      redirect_back(fallback_location: root_path) #元のページに戻る
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
      params.require(:comment).permit(:micropost_id, :user_id, :content, :picture)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to micropost_url if @comment.nil?
    end

end
