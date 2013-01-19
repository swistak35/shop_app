class Admin::AdminController < ApplicationController
	layout 'admin/application'

  before_filter :request_is_not_from_bot
  
  def request_is_not_from_bot
    authenticate_admin_admin! #if params[:bot_token] != "foobar"
  end

  #before_filter :authenticate_admin_admin!
end