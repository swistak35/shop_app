class Admin::OrdersController < Admin::AdminController
	def index
		@orders = Order.completed.order("ordered_at DESC")
	end

	def show
		@order = Order.find(params[:id])
	end
end