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

		@notice = case @order.add_product(@product, params[:quantity])
			when :added then "Product added to the cart."
			when :amount_increased then "Increased quantity of this product in the cart."
		end

		respond_to do |format|
			format.json do
				render json: { notice: @notice.to_s }
			end
			format.html do
				flash[:notice] = @notice
				redirect_to :back
			end
		end
	end

	def update
		@order.update_attributes(params[:order])
		@notice = "Cart updated successfully."

		respond_to do |format|
			format.html do
				redirect_to :back, notice: @notice
			end
			format.json do
				render json: { notice: @notice }
			end
		end
	end

	def payment
	end

	def complete
		respond_to do |format|
			format.html do
				if @order.update_attributes(params[:order])
					@order.complete!
				else
					render :payment
				end
			end
			format.json do
				if @order.update_attributes(params[:order])
					@order.complete!
					render json: { status: "success", order_id: @order.id }
				else
					msgs = @order.errors.full_messages.collect {|msg| msg }
					render json: { status: "failed", warning: msgs }
				end
			end
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