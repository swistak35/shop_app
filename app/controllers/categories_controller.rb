class CategoriesController < ShopController
	def show
		@category = Category.find(params[:id])
	end
end