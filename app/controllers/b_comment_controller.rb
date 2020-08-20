class BCommentController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
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
    @comment.delete
    redirect_to @comment.micropost, flash: { notice: 'コメントが削除されました' }
  end

  private

    def comment_params
      params.require(:comment).permit(:board_id, :content, :picture)
    end

    def correct_user
      @micropost = current_user.comments.find_by(id: params[:id])
      redirect_to microposts_url if @comment.nil?
    end

end
