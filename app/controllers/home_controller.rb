class HomeController < ShopController
	def index
		@products = Product.all
	end

	def first_spa
		render layout: 'first_spa'
	end
end