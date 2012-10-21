class Admin::ProductsController < Admin::ApplicationController
	def index
		@categories = Category.sorted
		@products_with_blank_category = Product.where("category_id IS NULL").sorted
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

	def edit
		@product = Product.find(params[:id])
	end

	def update
		@product = Product.find(params[:id])
		if @product.update_attributes(params[:product])
			redirect_to [:admin, @product], notice: "Product updated successfully"
		else
			render :edit
		end
	end

	def destroy
		@product = Product.find(params[:id])
		@product.destroy
		redirect_to admin_products_path, notice: "Product removed"
	end
end