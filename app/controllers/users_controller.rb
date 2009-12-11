class UsersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  resource_controller  
  
  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = "Successful created account!"
        redirect_to tworgies_path
      else
        render :action => :new
      end
    end
  end
end
