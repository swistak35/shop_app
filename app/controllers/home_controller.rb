class HomeController < ShopController
	def index
		@products = Product.all
	end

	def spa
		render layout: false
	end
end