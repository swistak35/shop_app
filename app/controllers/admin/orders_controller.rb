class Admin::OrdersController < Admin::ApplicationController
	def index
		@orders = Order.completed
	end

	def show
		@order = Order.find(params[:id])
	end
end