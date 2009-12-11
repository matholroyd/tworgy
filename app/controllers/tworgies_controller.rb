class TworgiesController < ApplicationController
  skip_before_filter :require_user, :only => :index
  resource_controller  

  def create 
    @tworgy = current_user.tworgies.new params[:tworgy]
    if @tworgy.save
      
    else
      
    end
  end
  
end
