class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_buyer
    if cookies[:user_id].present?
    	@current_buyer = Buyer.find(cookies[:user_id])
    else
    	@current_buyer = Buyer.create
    	cookies[:user_id] = { value: @current_buyer.id, expires: 1.week.from_now }
    end
    @current_buyer
  end
  helper_method :current_buyer
end
