class Admin::CategoriesController < Admin::AdminController
	before_filter :load_categories, except: [:destroy]

	def index
		@category = Category.new
	end

	def create
		@category = Category.new(params[:category])
		if @category.save
			redirect_to admin_categories_path, notice: "Category created successfully"
		else
			render :index
		end
	end

	def update
		@category = Category.find(params[:id])
		if @category.update_attributes(params[:category])
			redirect_to admin_categories_path, notice: "Category updated successfully"
		else
			render :index
		end
	end

	def destroy
		@category = Category.find(params[:id])
		@category.destroy
		Product.where(category_id: @category.id).update_all(category_id: nil)
		redirect_to admin_categories_path, notice: "Category removed"
	end

	private

	def load_categories
		@categories = Category.sorted
	end
end