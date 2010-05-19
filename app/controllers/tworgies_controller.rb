class TworgiesController < ApplicationController
  skip_before_filter :require_user, :only => :index
  before_filter :require_twitterer, :only => [:create, :update, :refresh]
  
  resource_controller  

  index.before do
    @tworgy = Tworgy.new
  end

  index.response do |wants|
    wants.html
    wants.json do 
      render :json => collection.to_json
    end
    
  end
  
  update.wants.html { redirect_to(tworgies_path) }

  def refresh
    current_user.repopulate_tworgies
    redirect_to tworgies_path
  end
  
  def create 
    @tworgy = current_user.tworgies.new params[:tworgy]
    if @tworgy.save
      redirect_to tworgies_path
    else
      render :index
    end
  end
  
  def members
    
    render :json => [].to_json
  end


  private 
  
  def collection
    @collection ||= params[:current_user_only] ? current_user.tworgies : Tworgy.all
  end
  
  def require_twitterer
    unless twitterer?
      flash[:error] = 'You need to have twitter credentials associated with your account to access this action'
      redirect_to tworgies_path
    end
  end
  
end
