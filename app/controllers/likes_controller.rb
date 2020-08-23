class LikesController < ApplicationController
  before_action :micropost_params

  def create
      like = current_user.likes.new(micropost_id: @micropost.id)
      like.save
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, micropost_id: @micropost.id).destroy
  end

  private
  
    def micropost_params
      @micropost = micropost.find(params[:micropost_id])
    end
end
