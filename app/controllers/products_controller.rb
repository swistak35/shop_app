class ProductsController < ShopController
	def index
		@products = Product.all
		respond_to do |format|
			format.json { render json: @products }
		end
	end
	
	def show
		@product = Product.find(params[:id])

		respond_to do |format|
			format.html
			format.json { render json: @product }
		end
	end

	def search
		@result = @search.result
		
		if params[:q][:name_cont].present? && params[:desc_search].present?
			params_desc = params[:q].clone
			params_desc[:desc_cont] = params_desc.delete(:name_cont)
			@result += Product.search(params_desc).result
		end
		@result.uniq!
	end
end