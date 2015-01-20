class HomeController < ApplicationController
  def index
    if user_signed_in? and current_user.team == nil
      @team = Team.new
    end
    render :layout => 'application'
  end
end
