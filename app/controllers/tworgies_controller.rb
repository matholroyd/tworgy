class TworgiesController < ApplicationController
  skip_before_filter :require_user, :only => :index
  before_filter :require_twitterer, :only => [:create, :update]
  
  resource_controller  

  index.before do
    @tworgy = Tworgy.new if current_user.twitterer?
  end

  def create 
    @tworgy = current_user.tworgies.new params[:tworgy]
    if @tworgy.save
      redirect_to tworgies_path
    else
      
    end
  end

  update.wants.html { redirect_to(tworgies_path) }

  private 
  
  def require_twitterer
    unless current_user.twitterer?
      flash[:error] = 'You need to have twitter credentials associated with your account to access this action'
      redirect_to tworgies_path
    end
  end
  
end
