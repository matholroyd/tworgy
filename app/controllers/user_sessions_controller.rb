class UserSessionsController < ApplicationController
  skip_before_filter :require_user

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        redirect_back_or_default tworgies_path
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    redirect_back_or_default tworgies_path
  end
end
