module ApplicationHelper
	def link_to_category(product)
		if product.category.present?
			link_to product.category.name, product.category
		else
			"none"
		end
	end

	def current_order
		current_buyer.current_order
	end
end
