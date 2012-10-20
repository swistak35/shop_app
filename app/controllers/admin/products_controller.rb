class Admin::ProductsController < Admin::ApplicationController
	def index
		
	end

	def show
		@product = Product.find(params[:id])
	end

	def new
		@product = Product.new
	end

	def create
		@product = Product.new(params[:product])
		if @product.save
			redirect_to [:admin, @product], notice: "Product created successfully"
		else
			render :new
		end
	end
end