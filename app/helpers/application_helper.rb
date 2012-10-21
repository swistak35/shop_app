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

	def all_categories
  	Category.all
  end

  def basket_info(amount)
  	case amount
  		when 0
  			"Cart is empty."
  		when 1
  			"There is 1 product in cart."
  		else
  			"There are #{amount} products in cart."
  	end
  end

  def nice_datetime(datetime)
    datetime.strftime("%d-%m-%Y %H:%M")
  end
end
