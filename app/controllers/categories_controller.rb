class CategoriesController < ApplicationController
	def index
	end

	def show
	end

	def find_category
		@category = Category.find(params[:id])
	end
end