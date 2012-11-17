class ShopController < ApplicationController
	before_filter :initialize_search_object

  def current_buyer
    if cookies[:user_id].present? && (buyer = Buyer.find(cookies[:user_id]))
      @current_buyer = buyer
    else
      @current_buyer = Buyer.create
      cookies[:user_id] = { value: @current_buyer.id, expires: 1.week.from_now }
    end
    @current_buyer
  end
  helper_method :current_buyer

  private
  
  def initialize_search_object
    @search = Product.search(params[:q])
  end
end