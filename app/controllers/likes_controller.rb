class LikesController < ApplicationController
  before_action :set_micropost

  def create
    @micropost = Micropost.find(params[:micropost_id])
    like = current_user.likes.build(micropost_id: params[:micropost_id])
    like.save
    @micropost.create_notification_by(current_user)
    respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
    end
  end

  def destroy
    # @micropost = Micropost.find(params[:micropost_id])
    like = Like.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
    like.destroy
  end

  private

    def set_micropost
      @micropost = Micropost.find(params[:micropost_id])
    end
end
