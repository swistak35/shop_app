class HomeController < ShopController
	def index
		@products = Product.all
	end
end