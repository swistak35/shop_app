class CartsController < ApplicationController
	def show
	end

	def add_product
		@product = Product.find(params[:id])
		current_buyer.current_order.items.create(product_id: @product.id, price: @product.price)
		redirect_to :back, notice: "Product added to the cart."
	end
end