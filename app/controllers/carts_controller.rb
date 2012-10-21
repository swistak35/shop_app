class CartsController < ApplicationController
	before_filter :find_order
	before_filter :check_amount_of_items, only: [:complete, :payment]
	
	def show
	end

	def add_product
		matching_items = @order.items.where("order_items.product_id = ?", params[:id])

		if matching_items.empty?
			product = Product.find(params[:id])
			@order.items.create(
				product_id: product.id,
				price: product.price,
				quantity: params[:quantity])
			flash[:notice] = "Product added to the cart."
		else
			order_item = matching_items.first
			if order_item.increase_quantity_by(params[:quantity])
				flash[:notice] = "Increased quantity of this product in the cart."
			end
		end
		redirect_to :back
	end

	def update
		@order.update_attributes(params[:order])
		redirect_to :back, notice: "Cart updated successfully."
	end

	def payment
	end

	def complete
		if @order.update_attributes(params[:order])
			@order.complete!
		else
			render :payment
		end
	end

	private

	def find_order
		@order = current_buyer.current_order
	end

	def check_amount_of_items
		if @order.amount_of_items.zero?
			redirect_to cart_path, alert: "Your cart is empty."
		end
	end
end