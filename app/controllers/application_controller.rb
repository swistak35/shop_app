class ApplicationController < ActionController::Base
  protect_from_forgery

  def all_categories
  	Category.all
  end
  helper_method :all_categories

  def current_buyer
    if cookies[:user_id].present?
    	@current_buyer = Buyer.find(cookies[:user_id])
    else
    	@current_buyer = Buyer.create
    	cookies[:user_id] = @current_buyer.id
    end
    @current_buyer
  end
  helper_method :current_buyer
end
