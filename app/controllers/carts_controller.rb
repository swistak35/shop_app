class CartsController < ShopController
	before_filter :find_order
	before_filter :check_amount_of_items, only: [:complete, :payment]
	
	def show
		respond_to do |format|
			format.html
			format.json { render json: current_buyer.current_order.to_json(include: :items) }
		end
	end

	def add_product
		@product = Product.find(params[:id])

		flash[:notice] = case @order.add_product(@product, params[:quantity])
			when :added then "Product added to the cart."
			when :amount_increased then "Increased quantity of this product in the cart."
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