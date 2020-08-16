class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      flash[:success] = 'コメントを投稿しました!'
      redirect_to comment.micropost
    else
      flash[:danger] = "コメント投稿に失敗しました"
      redirect_back(fallback_location: root_path) #元のページに戻る
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.delete
    redirect_to comment.micropost, flash: { notice: 'コメントが削除されました' }
  end

  private

    def comment_params
      params.require(:comment).permit(:micropost_id, :content)
    end

end
