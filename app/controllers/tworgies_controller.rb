class TworgiesController < ApplicationController
  skip_before_filter :require_user, :only => :index
  before_filter :require_twitterer, :only => [:create, :update, :refresh]
  
  resource_controller  

  index.response do |wants|
    wants.html
    wants.json do 
      # render :json => collection.serialize(:json, :attributes => 
      #   %w{id twitter_list_id name slug members_count subscribers_count uri latitude longitude} 
      # )
      render :json => collection.to_json
    end
    
  end

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


  update.wants.html { redirect_to(tworgies_path) }

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
