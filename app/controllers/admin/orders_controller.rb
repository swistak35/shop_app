class Admin::OrdersController < Admin::AdminController
	def index
		@orders = Order.completed.order("ordered_at DESC")
	end

  def order_items
    @order_items = OrderItem.select("order_items.id, products.name").joins(:order).joins(:product).where("orders.completed" => true)
    render json: @order_items
  end

	def show
		@order = Order.find(params[:id])
	end
end