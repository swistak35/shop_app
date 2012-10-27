class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :initialize_search_object

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

  def initialize_search_object
    @search = Product.search(params[:q])
  end
end
