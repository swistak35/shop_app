class OrderItem < ActiveRecord::Base
	attr_accessible :price, :product_id, :quantity, :order_id

	delegate :name, :desc, to: :product,
					prefix: true, allow_nil: true

	belongs_to :order
	belongs_to :product

	def cost
		(self.quantity * self.price).round(2)
	end

	def increase_quantity_by(quantity_to_add)
		quantity_to_add = quantity_to_add.to_i
		if quantity_to_add > 0
			self.quantity += quantity_to_add
			self.save
			true
		else
			false
		end
	end
end