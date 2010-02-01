class HomeController < ApplicationController
  skip_before_filter :require_user
  
  def index
    redirect_to tworgies_path
  end
  
  def testing
  end
end
