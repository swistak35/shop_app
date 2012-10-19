class CartsController < ApplicationController
	def show
	end

	def add_product
		@product = Product.find(params[:id])
		current_buyer.current_order.items.create(
			product_id: @product.id,
			price: @product.price,
			quantity: params[:quantity])
		redirect_to :back, notice: "Product added to the cart."
	end

	def update
		@order = current_buyer.current_order
		@order.update_attributes(params[:order])
		redirect_to :back, notice: "Cart updated successfully."
	end
end