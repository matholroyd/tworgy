class TworgiesController < ApplicationController
  skip_before_filter :require_user, :only => :index
  before_filter :require_twitterer, :only => [:create, :update, :refresh]
  
  resource_controller  

  def index
    if twitterer?
      @tworgy = Tworgy.new
      @tworgies = current_user.tworgies
      @tworgy_latlngs = @tworgies.inject({}) {|hash, t| hash[t.id] = {:lng => t.longitude, :lat => t.latitude}; hash}
      @tjson = @tworgies.to_json
    else
      @tworgy_latlngs = []
    end
    @tworgy_latlngs = @tworgy_latlngs.to_json
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
  
  def require_twitterer
    unless twitterer?
      flash[:error] = 'You need to have twitter credentials associated with your account to access this action'
      redirect_to tworgies_path
    end
  end
  
end
