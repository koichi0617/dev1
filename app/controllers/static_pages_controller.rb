class StaticPagesController < ApplicationController
  def home
    render :layout => "home_layout"
  end

end
