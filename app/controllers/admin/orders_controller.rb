class Admin::OrdersController < Admin::ApplicationController
	def index
		@orders = Order.completed.order("ordered_at DESC")
	end

	def show
		@order = Order.find(params[:id])
	end
end