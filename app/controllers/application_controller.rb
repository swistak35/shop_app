class ApplicationController < ActionController::Base
  protect_from_forgery

  def all_categories
  	Category.all
  end
  helper_method :all_categories
end
