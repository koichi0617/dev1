class BoardsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def index
    @feed_items = Board.all
    @feed_items = @feed_items.page(params[:page])
  end

  def new
    if logged_in?
      @board = current_user.boards.build
      @feed_items = current_user.feed_board.paginate(page: params[:page])
    else
      render template: 'sessions/new'
    end
  end

  def create
    if logged_in?
      @board = current_user.boards.build(board_params)
      if @board.save
        flash[:success] = "投稿されました"
        redirect_to boards_url
      else
        @feed_items = []
        render 'static_pages/index'
      end
    else
      render template: 'sessions/new'
    end
  end

  def destroy
    @board.destroy
    flash[:success] = "削除されました"
    redirect_to request.referrer || board_url
  end

  def show
    @board = Board.find(params[:id])
    @comment = Comment.new(board_id: @board.id)
  end

  private

    def board_params
      params.require(:board).permit(:name, :content, :picture)
    end

    def correct_user
      @board = current_user.boards.find_by(id: params[:id])
      redirect_to root_url if @board.nil?
    end

end
