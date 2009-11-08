class ActivitiesController < ApplicationController
  skip_before_filter :require_user

  make_resourceful do
    actions :all
    publish :json, :attributes => %w{id title}
  end
  
  def create
    request.body.each{|body_part|
      params = ActiveSupport::JSON.decode(body_part)
      logger.debug(params.inspect)
      Activity.create! params['activity']
    }
    render :nothing => true
  end
end
