class CategoriesController < ShopController
	def index
		@categories = Category.all
		respond_to do |format|
			format.json { render json: @categories }
		end
	end

	def show
		@category = Category.find(params[:id])
		respond_to do |format|
			format.html
			format.json do
				render json: @category.to_json( include: {
						products: {
							only: [:id, :name, :price]
						}
					})
			end
		end
	end
end